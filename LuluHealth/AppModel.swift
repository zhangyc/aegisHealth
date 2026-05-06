//
//  AppModel.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import Combine
import Foundation
import SwiftUI

enum HealthAccessState {
    case unknown
    case authorized
    case denied
}

enum LogCaptureKind: String, Identifiable {
    case intake
    case workout
    case weight
    case status

    var id: String { rawValue }

    var title: String {
        switch self {
        case .intake: "记录饮食"
        case .workout: "记录运动"
        case .weight: "记录体重"
        case .status: "记录状态"
        }
    }

    var helper: String {
        switch self {
        case .intake: "把摄入补完整，系统才能正确判断缺口。"
        case .workout: "补上运动，燃烧曲线才会真实。"
        case .weight: "体重用于校准长期趋势，不用每天焦虑。"
        case .status: "记录饥饿、疲劳和恢复感。"
        }
    }
}

struct UserPreferences {
    var targetWeight: Double
    var dailyDeficitGoal: Int
    var weeklyPace: String
    var reminderStyle: String

    static let `default` = UserPreferences(
        targetWeight: 72,
        dailyDeficitGoal: 500,
        weeklyPace: "温和减脂",
        reminderStyle: "午餐后 / 晚间"
    )
}

@MainActor
final class AppModel: ObservableObject {
    @Published var healthAccessState: HealthAccessState = .unknown
    @Published var hasTodayData = false
    @Published var activeLogCapture: LogCaptureKind?
    @Published var preferences = UserPreferences.default
    @Published var todaySnapshot: TodaySnapshot = .placeholder
    @Published var healthErrorMessage: String?

    private let healthKitService = HealthKitService()

    init() {
        healthKitService.onUpdate = { [weak self] data in
            self?.applyHealthData(data)
        }

        healthAccessState = healthKitService.currentAccessState()

        if healthAccessState == .authorized {
            Task {
                try? await healthKitService.startIfAuthorized()
            }
        }
    }

    func requestHealthAccess() {
        Task {
            do {
                try await healthKitService.requestAuthorization()
                healthAccessState = .authorized
                healthErrorMessage = nil
            } catch {
                healthAccessState = .denied
                healthErrorMessage = "Health 权限请求失败。"
            }
        }
    }

    func markHealthDenied() {
        healthAccessState = .denied
        hasTodayData = false
        todaySnapshot = .placeholder
    }

    func openLogCapture(_ kind: LogCaptureKind) {
        activeLogCapture = kind
    }

    func completeCapture() {
        activeLogCapture = nil
    }

    func updatePreferences(targetWeight: Double, dailyDeficitGoal: Int, weeklyPace: String, reminderStyle: String) {
        preferences = UserPreferences(
            targetWeight: targetWeight,
            dailyDeficitGoal: dailyDeficitGoal,
            weeklyPace: weeklyPace,
            reminderStyle: reminderStyle
        )
    }

    private func applyHealthData(_ data: HealthKitDailyData) {
        hasTodayData = data.hasMeaningfulData
        todaySnapshot = data.hasMeaningfulData ? TodaySnapshot.fromHealthData(data) : .placeholder
    }
}
