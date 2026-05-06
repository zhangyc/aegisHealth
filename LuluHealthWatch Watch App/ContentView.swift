//
//  ContentView.swift
//  LuluHealthWatch Watch App
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

private enum WatchTheme {
    static let bgTop = Color(red: 0.03, green: 0.06, blue: 0.13)
    static let bgMid = Color(red: 0.07, green: 0.10, blue: 0.18)
    static let bgBottom = Color(red: 0.04, green: 0.06, blue: 0.12)
    static let glass = Color.white.opacity(0.08)
    static let stroke = Color.white.opacity(0.10)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.72)
    static let textTertiary = Color.white.opacity(0.48)
    static let energy = Color(red: 1.0, green: 0.48, blue: 0.10)
    static let warm = Color(red: 1.0, green: 0.72, blue: 0.30)
    static let intake = Color(red: 0.39, green: 0.82, blue: 1.0)
    static let deficit = Color(red: 0.20, green: 0.82, blue: 0.49)
}

private struct WatchEnergySnapshot {
    let burned: Int
    let intake: Int
    let balance: Int
    let active: Int
    let resting: Int
    let goalProgress: Double
    let status: String
    let nextStep: String

    static let mock = WatchEnergySnapshot(
        burned: 2_346,
        intake: 1_842,
        balance: -504,
        active: 2_012,
        resting: 334,
        goalProgress: 0.78,
        status: "稳定赤字",
        nextStep: "今晚再走 18 分钟，赤字会更稳。"
    )
}

struct ContentView: View {
    private let snapshot = WatchEnergySnapshot.mock

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                WatchHero(snapshot: snapshot)
                WatchBalanceStrip(snapshot: snapshot)
                WatchSourceRow(snapshot: snapshot)
                WatchReminderCard(message: snapshot.nextStep)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
        .background(WatchBackground())
    }
}

private struct WatchBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [WatchTheme.bgTop, WatchTheme.bgMid, WatchTheme.bgBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(WatchTheme.energy.opacity(0.22))
                .frame(width: 120, height: 120)
                .blur(radius: 36)
                .offset(x: 44, y: -38)

            Circle()
                .fill(WatchTheme.intake.opacity(0.12))
                .frame(width: 110, height: 110)
                .blur(radius: 34)
                .offset(x: -42, y: 84)
        }
        .ignoresSafeArea()
    }
}

private struct WatchHero: View {
    let snapshot: WatchEnergySnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Today Burn")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(WatchTheme.textTertiary)
                    Text(snapshot.status)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(snapshot.balance < 0 ? WatchTheme.deficit : WatchTheme.energy)
                }

                Spacer()

                EnergyRing(progress: snapshot.goalProgress)
            }

            HStack(alignment: .bottom, spacing: 4) {
                Text("\(snapshot.burned)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(WatchTheme.textPrimary)
                Text("kcal")
                    .font(.caption)
                    .foregroundStyle(WatchTheme.textSecondary)
                    .padding(.bottom, 4)
            }

            Text("身体正在持续燃烧与转化能量。")
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)

            EnergyFlowBand()
                .frame(height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(12)
        .background(WatchGlassCard())
    }
}

private struct EnergyRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.10), lineWidth: 6)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [WatchTheme.warm, WatchTheme.energy, Color(red: 1.0, green: 0.35, blue: 0.30)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 1) {
                Text("\(Int(progress * 100))%")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(WatchTheme.textPrimary)
                Text("goal")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundStyle(WatchTheme.textTertiary)
            }
        }
        .frame(width: 52, height: 52)
    }
}

private struct EnergyFlowBand: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.03))

            HStack(spacing: 0) {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                WatchTheme.intake.opacity(0.20),
                                WatchTheme.energy.opacity(0.85),
                                WatchTheme.warm.opacity(0.95)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .blur(radius: 2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 14)
            }

            HStack(spacing: 10) {
                GlowNode(color: WatchTheme.intake, size: 9)
                GlowNode(color: WatchTheme.energy, size: 14)
                GlowNode(color: WatchTheme.warm, size: 10)
            }
        }
    }
}

private struct GlowNode: View {
    let color: Color
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .shadow(color: color.opacity(0.65), radius: 8)
    }
}

private struct WatchBalanceStrip: View {
    let snapshot: WatchEnergySnapshot

    var body: some View {
        HStack(spacing: 8) {
            WatchMetricChip(
                title: snapshot.balance < 0 ? "缺口" : "积压",
                value: "\(abs(snapshot.balance))",
                suffix: "kcal",
                tint: snapshot.balance < 0 ? WatchTheme.deficit : WatchTheme.energy
            )
            WatchMetricChip(
                title: "摄入",
                value: "\(snapshot.intake)",
                suffix: "kcal",
                tint: WatchTheme.intake
            )
        }
    }
}

private struct WatchMetricChip: View {
    let title: String
    let value: String
    let suffix: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(WatchTheme.textTertiary)
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                Text(value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(WatchTheme.textPrimary)
                Text(suffix)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(WatchTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(tint.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.18), lineWidth: 1)
                )
        )
    }
}

private struct WatchSourceRow: View {
    let snapshot: WatchEnergySnapshot

    var body: some View {
        HStack(spacing: 8) {
            WatchSourceCard(title: "Active", value: snapshot.active, tint: WatchTheme.energy)
            WatchSourceCard(title: "Rest", value: snapshot.resting, tint: WatchTheme.intake)
        }
    }
}

private struct WatchSourceCard: View {
    let title: String
    let value: Int
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Circle()
                .fill(tint)
                .frame(width: 8, height: 8)
                .shadow(color: tint.opacity(0.6), radius: 6)
            Text(title)
                .font(.caption2)
                .foregroundStyle(WatchTheme.textTertiary)
            Text("\(value)")
                .font(.headline.monospacedDigit())
                .foregroundStyle(WatchTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(WatchGlassCard(cornerRadius: 16))
    }
}

private struct WatchReminderCard: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Next")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(WatchTheme.energy)
            Text(message)
                .font(.caption)
                .foregroundStyle(WatchTheme.textSecondary)
        }
        .padding(12)
        .background(WatchGlassCard())
    }
}

private struct WatchGlassCard: View {
    var cornerRadius: CGFloat = 18

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(WatchTheme.glass)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(WatchTheme.stroke, lineWidth: 1)
            )
    }
}

#Preview {
    ContentView()
}
