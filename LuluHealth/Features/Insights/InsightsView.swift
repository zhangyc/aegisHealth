//
//  InsightsView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import Charts
import SwiftUI

private struct InsightHourPoint: Identifiable {
    let id = UUID()
    let hour: String
    let intake: Int
    let burn: Int
}

private let insightHours = [
    InsightHourPoint(hour: "6", intake: 0, burn: 120),
    InsightHourPoint(hour: "9", intake: 420, burn: 310),
    InsightHourPoint(hour: "12", intake: 780, burn: 620),
    InsightHourPoint(hour: "15", intake: 900, burn: 980),
    InsightHourPoint(hour: "18", intake: 1420, burn: 1560),
    InsightHourPoint(hour: "21", intake: 1842, burn: 2346)
]

struct InsightsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                InsightsHero()
                InsightsPatternChart()
                InsightsFindings()
                InsightsBestWindow()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.md)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
    }
}

private struct InsightsHero: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionTitle(eyebrow: "Insights", title: "行为洞察")
                Text("找出你最容易形成赤字的行为，而不是只看总卡路里。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                HStack(spacing: AppTheme.Spacing.md) {
                    InsightBadge(title: "下午 4-7 点最稳", color: AppTheme.Colors.deficit)
                    InsightBadge(title: "周末最容易超吃", color: AppTheme.Colors.heatMagenta)
                }
            }
        }
    }
}

private struct InsightsPatternChart: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("今日能量交汇")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Chart(insightHours) { point in
                    LineMark(x: .value("Hour", point.hour), y: .value("Intake", point.intake))
                        .foregroundStyle(AppTheme.Colors.intake)
                        .lineStyle(.init(lineWidth: 3, lineCap: .round))
                    LineMark(x: .value("Hour", point.hour), y: .value("Burn", point.burn))
                        .foregroundStyle(AppTheme.Colors.energyCore)
                        .lineStyle(.init(lineWidth: 3, lineCap: .round))
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

                HStack(spacing: 16) {
                    InsightLegend(title: "摄入", color: AppTheme.Colors.intake)
                    InsightLegend(title: "燃烧", color: AppTheme.Colors.energyCore)
                }
            }
        }
    }
}

private struct InsightsFindings: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("今天发现")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            ForEach([
                ("上午补给偏少，导致午餐摄入过快。", AppTheme.Colors.heatMagenta),
                ("下午活动把摄入反超，形成了今天最关键的赤字窗口。", AppTheme.Colors.deficit),
                ("晚间如果再加 20 分钟步行，今天赤字会更稳。", AppTheme.Colors.energyCore)
            ], id: \.0) { finding in
                GlassCard {
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(finding.1)
                            .frame(width: 10, height: 10)
                            .padding(.top, 6)
                        Text(finding.0)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
    }
}

private struct InsightsBestWindow: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("最佳燃脂窗口")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("16:20 - 19:10")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("这个时间段你的运动消耗最容易超过摄入，建议把训练固定在这里。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
    }
}

private struct InsightBadge: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(AppTheme.Colors.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule(style: .continuous).fill(color.opacity(0.16)))
    }
}

private struct InsightLegend: View {
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(title)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }
}

#Preview {
    InsightsView()
}
