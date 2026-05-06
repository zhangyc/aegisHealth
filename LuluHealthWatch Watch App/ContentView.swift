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
    let burnTrend: [Double]

    static let empty = WatchEnergySnapshot(
        burned: 0,
        intake: 0,
        balance: 0,
        active: 0,
        resting: 0,
        goalProgress: 0,
        status: "等待同步",
        nextStep: "先在 iPhone 里授权 Health。",
        burnTrend: []
    )
}

struct ContentView: View {
    private let snapshot = WatchEnergySnapshot.empty

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                WatchHero(snapshot: snapshot)
                WatchBurnPanel(snapshot: snapshot)
                WatchCommandCard(message: snapshot.nextStep)
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
                .frame(width: 118, height: 118)
                .blur(radius: 34)
                .offset(x: 42, y: -32)

            Circle()
                .fill(WatchTheme.intake.opacity(0.10))
                .frame(width: 106, height: 106)
                .blur(radius: 30)
                .offset(x: -42, y: 88)
        }
        .ignoresSafeArea()
    }
}

private struct WatchHero: View {
    let snapshot: WatchEnergySnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Now Burning")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(WatchTheme.textTertiary)
                    Text(snapshot.status)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(snapshot.balance < 0 ? WatchTheme.deficit : WatchTheme.energy)
                }

                Spacer()

                ProgressHalo(progress: snapshot.goalProgress)
            }

            HStack(alignment: .bottom, spacing: 4) {
                Text("\(abs(snapshot.balance))")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(WatchTheme.textPrimary)
                Text("kcal")
                    .font(.caption)
                    .foregroundStyle(WatchTheme.textSecondary)
                    .padding(.bottom, 4)
            }

            Text(snapshot.status == "等待同步" ? "手表端暂时还没有真实能量数据。" : snapshot.balance < 0 ? "缺口正在扩大。" : "积压正在增加。")
                .font(.caption2)
                .foregroundStyle(WatchTheme.textSecondary)
        }
        .padding(12)
        .background(WatchGlassCard())
    }
}

private struct ProgressHalo: View {
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

            Text("\(Int(progress * 100))%")
                .font(.caption2.weight(.bold))
                .foregroundStyle(WatchTheme.textPrimary)
        }
        .frame(width: 50, height: 50)
    }
}

private struct WatchBurnPanel: View {
    let snapshot: WatchEnergySnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("实时燃烧")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(WatchTheme.textPrimary)
                Spacer()
                Text(snapshot.burnTrend.isEmpty ? "Sync" : "Now")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(snapshot.burnTrend.isEmpty ? WatchTheme.textTertiary : WatchTheme.energy)
            }

            WatchBurnTrend(trend: snapshot.burnTrend)
                .frame(height: 78)

            HStack(spacing: 8) {
                WatchMiniMetric(title: "Active", value: snapshot.active, tint: WatchTheme.energy)
                WatchMiniMetric(title: "Rest", value: snapshot.resting, tint: WatchTheme.intake)
            }
        }
        .padding(12)
        .background(WatchGlassCard())
    }
}

private struct WatchBurnTrend: View {
    let trend: [Double]

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let maxValue = max(trend.max() ?? 1, 1)
            let points = trend.enumerated().map { index, value in
                CGPoint(
                    x: width * CGFloat(index) / CGFloat(max(trend.count - 1, 1)),
                    y: height - (height * CGFloat(value / maxValue))
                )
            }

            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )

                ForEach(0..<2, id: \.self) { line in
                    Rectangle()
                        .fill(Color.white.opacity(0.05))
                        .frame(height: 1)
                        .offset(y: -CGFloat(line + 1) * height / 3)
                }

                if points.isEmpty {
                    VStack(spacing: 4) {
                        Text("No Live Burn Yet")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(WatchTheme.textSecondary)
                        Text("等主 App 同步真实数据")
                            .font(.caption2)
                            .foregroundStyle(WatchTheme.textTertiary)
                    }
                }

                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [WatchTheme.warm, WatchTheme.energy, Color(red: 1.0, green: 0.35, blue: 0.30)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3.2, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: WatchTheme.energy.opacity(0.45), radius: 8)

                if let last = points.last {
                    Circle()
                        .fill(WatchTheme.warm)
                        .frame(width: 8, height: 8)
                        .shadow(color: WatchTheme.warm.opacity(0.65), radius: 8)
                        .position(last)
                }
            }
        }
    }
}

private struct WatchMiniMetric: View {
    let title: String
    let value: Int
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(WatchTheme.textTertiary)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Circle()
                    .fill(tint)
                    .frame(width: 7, height: 7)
                Text("\(value)")
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(WatchTheme.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
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

private struct WatchCommandCard: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Next")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(WatchTheme.energy)
            Text(message)
                .font(.caption.weight(.medium))
                .foregroundStyle(WatchTheme.textPrimary)
            Text("现在只需要一个动作。")
                .font(.caption2)
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
