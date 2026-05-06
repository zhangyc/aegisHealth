//
//  JourneyView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import Charts
import SwiftUI

private struct JourneyWeekPoint: Identifiable {
    let id = UUID()
    let day: String
    let weight: Double
    let deficit: Int
}

private let journeyPoints = [
    JourneyWeekPoint(day: "Mon", weight: 78.9, deficit: 320),
    JourneyWeekPoint(day: "Tue", weight: 78.7, deficit: 410),
    JourneyWeekPoint(day: "Wed", weight: 78.6, deficit: 380),
    JourneyWeekPoint(day: "Thu", weight: 78.5, deficit: 520),
    JourneyWeekPoint(day: "Fri", weight: 78.4, deficit: 460),
    JourneyWeekPoint(day: "Sat", weight: 78.4, deficit: 290),
    JourneyWeekPoint(day: "Sun", weight: 78.3, deficit: 540)
]

struct JourneyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                JourneyHero()
                JourneyTrendCard()
                JourneyDeficitSummary()
                JourneyMilestones()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.md)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
    }
}

private struct JourneyHero: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionTitle(eyebrow: "Journey", title: "减脂进程")

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("78.3 kg")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Text("已比起点下降 1.9 kg")
                            .foregroundStyle(AppTheme.Colors.deficit)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("目标 72.0 kg")
                            .font(.headline)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Text("预计 8 周达成")
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }

                ProgressView(value: 0.23)
                    .tint(AppTheme.Colors.energyCore)
            }
        }
    }
}

private struct JourneyTrendCard: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack {
                    Text("7 天体重趋势")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Spacer()
                    Text("-0.6 kg")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.deficit)
                }

                Chart(journeyPoints) { point in
                    AreaMark(
                        x: .value("Day", point.day),
                        y: .value("Weight", point.weight)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                AppTheme.Colors.heatMagenta.opacity(0.28),
                                AppTheme.Colors.heatMagenta.opacity(0.03)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    LineMark(
                        x: .value("Day", point.day),
                        y: .value("Weight", point.weight)
                    )
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))

                    PointMark(
                        x: .value("Day", point.day),
                        y: .value("Weight", point.weight)
                    )
                    .foregroundStyle(AppTheme.Colors.energyCore)
                }
                .frame(height: 220)
                .chartYAxis {
                    AxisMarks(position: .leading) {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(AppTheme.Colors.strokeSoft)
                        AxisValueLabel()
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                    }
                }
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel()
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                    }
                }
            }
        }
    }
}

private struct JourneyDeficitSummary: View {
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        return LazyVGrid(columns: columns, spacing: AppTheme.Spacing.md) {
            JourneyMetricCard(title: "周均赤字", value: "417", suffix: "kcal", accent: AppTheme.Colors.energyCore)
            JourneyMetricCard(title: "最稳的一天", value: "周四", suffix: "", accent: AppTheme.Colors.deficit)
            JourneyMetricCard(title: "代谢状态", value: "稳定", suffix: "", accent: AppTheme.Colors.intake)
            JourneyMetricCard(title: "波动区间", value: "0.6", suffix: "kg", accent: AppTheme.Colors.heatMagenta)
        }
    }
}

private struct JourneyMetricCard: View {
    let title: String
    let value: String
    let suffix: String
    let accent: Color

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    if !suffix.isEmpty {
                        Text(suffix)
                            .font(.headline)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
                Capsule()
                    .fill(accent.opacity(0.9))
                    .frame(width: 56, height: 6)
            }
        }
    }
}

private struct JourneyMilestones: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("关键节点")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                ForEach([
                    "继续保持当前赤字，11 天后预计跌破 78 kg。",
                    "过去 7 天训练消耗贡献了 31% 的总赤字。",
                    "周末摄入偏高，是目前最明显的减脂阻力。 "
                ], id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(AppTheme.Colors.energyCore)
                            .frame(width: 8, height: 8)
                            .padding(.top, 6)
                        Text(item)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
    }
}

#Preview {
    JourneyView()
}
