//
//  HealthKitService.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import Foundation
import HealthKit

struct HealthKitDailyData {
    let activeEnergy: Double
    let basalEnergy: Double
    let dietaryEnergy: Double
    let workoutEnergy: Double
    let bodyMass: Double?
    let hourlyBurn: [Double]
    let hourlyIntake: [Double]

    var totalBurn: Double {
        basalEnergy + activeEnergy + digestionEnergy
    }

    var digestionEnergy: Double {
        dietaryEnergy * 0.1
    }

    var deficit: Double {
        dietaryEnergy - totalBurn
    }

    var hasMeaningfulData: Bool {
        totalBurn > 0 || dietaryEnergy > 0
    }
}

final class HealthKitService {
    private let store = HKHealthStore()
    private var anchors: [String: HKQueryAnchor] = [:]
    private var hasStartedObservers = false

    var onUpdate: ((HealthKitDailyData) -> Void)?

    private let activeType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    private let basalType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
    private let dietaryType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
    private let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
    private let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    private let workoutType = HKObjectType.workoutType()

    private var observedTypes: [HKSampleType] {
        [activeType, basalType, dietaryType, bodyMassType, workoutType]
    }

    private var shareTypes: Set<HKSampleType> {
        [dietaryType, bodyMassType, workoutType]
    }

    private var readTypes: Set<HKObjectType> {
        [activeType, basalType, dietaryType, bodyMassType, heartRateType, workoutType]
    }

    func currentAccessState() -> HealthAccessState {
        guard HKHealthStore.isHealthDataAvailable() else { return .denied }

        switch store.authorizationStatus(for: dietaryType) {
        case .sharingAuthorized:
            return .authorized
        case .sharingDenied:
            return .denied
        case .notDetermined:
            return .unknown
        @unknown default:
            return .unknown
        }
    }

    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "HealthKitUnavailable", code: 1)
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            store.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: NSError(domain: "HealthKitAuthorization", code: 2))
                }
            }
        }

        startObserversIfNeeded()
        try await refresh()
    }

    func startIfAuthorized() async throws {
        guard currentAccessState() == .authorized else { return }
        startObserversIfNeeded()
        try await refresh()
    }

    func refresh() async throws {
        let now = Date()
        let start = Calendar.current.startOfDay(for: now)

        async let active = cumulativeSum(for: activeType, start: start, end: now)
        async let basal = cumulativeSum(for: basalType, start: start, end: now)
        async let dietary = cumulativeSum(for: dietaryType, start: start, end: now)
        async let workout = workoutEnergy(start: start, end: now)
        async let bodyMass = latestBodyMass()
        async let hourlyBurn = hourlySeries(for: activeType, start: start, end: now)
        async let hourlyIntake = hourlySeries(for: dietaryType, start: start, end: now)

        let snapshot = HealthKitDailyData(
            activeEnergy: try await active,
            basalEnergy: try await basal,
            dietaryEnergy: try await dietary,
            workoutEnergy: try await workout,
            bodyMass: try await bodyMass,
            hourlyBurn: try await hourlyBurn,
            hourlyIntake: try await hourlyIntake
        )

        await MainActor.run {
            onUpdate?(snapshot)
        }
    }

    private func startObserversIfNeeded() {
        guard !hasStartedObservers else { return }
        hasStartedObservers = true

        for type in observedTypes {
            let query = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, completion, _ in
                guard let self else {
                    completion()
                    return
                }

                self.syncAnchoredChanges(for: type) {
                    completion()
                }
            }

            store.execute(query)
            store.enableBackgroundDelivery(for: type, frequency: .immediate) { _, _ in }
        }
    }

    private func syncAnchoredChanges(for type: HKSampleType, completion: @escaping () -> Void) {
        let key = type.identifier
        let query = HKAnchoredObjectQuery(type: type, predicate: nil, anchor: anchors[key], limit: HKObjectQueryNoLimit) { [weak self] _, _, _, newAnchor, _ in
            guard let self else {
                completion()
                return
            }

            self.anchors[key] = newAnchor

            Task {
                try? await self.refresh()
                completion()
            }
        }

        store.execute(query)
    }

    private func cumulativeSum(for type: HKQuantityType, start: Date, end: Date) async throws -> Double {
        try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let value = statistics?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                continuation.resume(returning: value)
            }

            store.execute(query)
        }
    }

    private func workoutEnergy(start: Date, end: Date) async throws -> Double {
        try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
            let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let value = (samples as? [HKWorkout])?.reduce(0) { partial, workout in
                    let energy = workout.statistics(for: self.activeType)?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                    return partial + energy
                } ?? 0

                continuation.resume(returning: value)
            }

            store.execute(query)
        }
    }

    private func latestBodyMass() async throws -> Double? {
        try await withCheckedThrowingContinuation { continuation in
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: bodyMassType, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let sample = samples?.first as? HKQuantitySample
                let value = sample?.quantity.doubleValue(for: .gramUnit(with: .kilo))
                continuation.resume(returning: value)
            }

            store.execute(query)
        }
    }

    private func hourlySeries(for type: HKQuantityType, start: Date, end: Date) async throws -> [Double] {
        try await withCheckedThrowingContinuation { continuation in
            var interval = DateComponents()
            interval.hour = 1

            let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
            let query = HKStatisticsCollectionQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: start,
                intervalComponents: interval
            )

            query.initialResultsHandler = { _, collection, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                var values: [Double] = []
                collection?.enumerateStatistics(from: start, to: end) { statistics, _ in
                    values.append(statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0)
                }
                continuation.resume(returning: values)
            }

            store.execute(query)
        }
    }
}
