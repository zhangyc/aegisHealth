//
//  TodayView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import Charts
import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var appModel: AppModel
    let snapshot: TodaySnapshot

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                if appModel.healthAccessState != .authorized {
                    HealthAccessCard()
                }
                TodayHeader(snapshot: snapshot)
                if appModel.hasTodayData {
                    BodyEnergyHero(snapshot: snapshot)
                    MetricGrid(metrics: snapshot.metrics)
                    BurnBreakdownSection(components: snapshot.components)
                    EnergyTimelineSection(points: snapshot.timeline)
                    RecommendationSection(message: snapshot.recommendation)
                } else {
                    TodayEmptyState()
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.md)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
    }
}

private struct HealthAccessCard: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("连接 Apple Health")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("先拿到燃烧、摄入和体重权限，首页才会变成真实的身体能量流。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                HStack(spacing: AppTheme.Spacing.md) {
                    Button {
                        appModel.requestHealthAccess()
                    } label: {
                        Text("授权 Health")
                            .font(.headline)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(AppTheme.Colors.energyCore.opacity(0.18))
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        appModel.markHealthDenied()
                    } label: {
                        Text("稍后")
                            .font(.headline)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(AppTheme.Colors.surfaceGlass)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct TodayEmptyState: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                Text("今天还没有形成能量图。")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("现在缺的不是设计，而是数据。连上 Health 或先补一条饮食 / 运动记录，首页就会开始燃烧起来。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                HStack(spacing: AppTheme.Spacing.md) {
                    Button {
                        appModel.openLogCapture(.intake)
                    } label: {
                        TodayEmptyAction(title: "补记饮食", tint: AppTheme.Colors.intake)
                    }
                    .buttonStyle(.plain)

                    Button {
                        appModel.openLogCapture(.workout)
                    } label: {
                        TodayEmptyAction(title: "补记运动", tint: AppTheme.Colors.energyCore)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct TodayEmptyAction: View {
    let title: String
    let tint: Color

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(AppTheme.Colors.textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule(style: .continuous)
                    .fill(tint.opacity(0.18))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(tint.opacity(0.22), lineWidth: 1)
                    )
            )
            .frame(maxWidth: .infinity)
    }
}

private struct TodayHeader: View {
    @EnvironmentObject private var appModel: AppModel
    let snapshot: TodaySnapshot

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(snapshot.title)
                    .font(.headline.weight(.medium))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Text(appModel.hasTodayData ? "\(snapshot.burnedCalories.formatted()) kcal" : "--")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text(appModel.hasTodayData ? "今日身体总燃烧" : "等待今日能量数据")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }

            Spacer()

            Text(appModel.hasTodayData ? snapshot.status : "No Data")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule(style: .continuous)
                        .fill((appModel.hasTodayData ? AppTheme.Colors.deficit : AppTheme.Colors.textTertiary).opacity(0.18))
                        .overlay(Capsule(style: .continuous).stroke((appModel.hasTodayData ? AppTheme.Colors.deficit : AppTheme.Colors.textTertiary).opacity(0.35), lineWidth: 1))
                )
        }
    }
}

private struct BodyEnergyHero: View {
    let snapshot: TodaySnapshot

    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.energyCore.opacity(0.18))
                        .frame(width: 230, height: 230)
                        .blur(radius: 35)

                    Circle()
                        .fill(AppTheme.Colors.heatMagenta.opacity(0.12))
                        .frame(width: 170, height: 170)
                        .blur(radius: 18)
                        .offset(y: -25)

                    ReferenceBodyView()
                        .frame(width: 174, height: 390)
                        .shadow(color: AppTheme.Colors.energyCore.opacity(0.22), radius: 28)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                HStack(spacing: AppTheme.Spacing.md) {
                    EnergyChip(label: "基础代谢", value: "1,182")
                    EnergyChip(label: "消化", value: "138")
                    EnergyChip(label: "运动", value: "232")
                }

                Text("身体正在持续维持体温、处理食物并输出活动能量。")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct ReferenceBodyView: View {
    var body: some View {
        if let uiImage = UIImage(named: "body-reference-transparent") {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Color.clear
        }
    }
}

private struct EnergyChip: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("\(value) kcal")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MetricGrid: View {
    let metrics: [TodaySnapshot.Metric]
    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.md),
        GridItem(.flexible(), spacing: AppTheme.Spacing.md)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppTheme.Spacing.md) {
            ForEach(metrics) { metric in
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(metric.title)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                        Text(metric.value)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(metric.tint)
                        Text(metric.detail)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                    }
                }
            }
        }
    }
}

private struct BurnBreakdownSection: View {
    let components: [TodaySnapshot.BurnComponent]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionTitle(eyebrow: "Burn Breakdown", title: "燃烧来源")
            ForEach(components) { component in
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(component.title)
                                .font(.headline)
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            Spacer()
                            Text("\(component.calories) kcal")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(component.tint)
                        }

                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(AppTheme.Colors.strokeSoft)
                                Capsule()
                                    .fill(component.tint.opacity(0.9))
                                    .frame(width: geometry.size.width * component.share)
                            }
                        }
                        .frame(height: 8)

                        HStack {
                            Text("\(Int(component.share * 100))% of total burn")
                                .font(.footnote)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                            Spacer()
                            Text(component.trend)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                        }
                    }
                }
            }
        }
    }
}

private struct EnergyTimelineSection: View {
    let points: [TodaySnapshot.EnergyPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionTitle(eyebrow: "Energy Timeline", title: "摄入与燃烧节奏")
            GlassCard {
                Chart {
                    ForEach(points) { point in
                        AreaMark(
                            x: .value("Hour", point.hour),
                            y: .value("Burn", point.burn)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    AppTheme.Colors.energyCore.opacity(0.35),
                                    AppTheme.Colors.energyCore.opacity(0.02)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                        LineMark(
                            x: .value("Hour", point.hour),
                            y: .value("Burn", point.burn)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(AppTheme.Colors.energyCore)
                        .lineStyle(.init(lineWidth: 3))

                        BarMark(
                            x: .value("Hour", point.hour),
                            y: .value("Intake", point.intake)
                        )
                        .foregroundStyle(AppTheme.Colors.intake.opacity(0.65))
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                }
                .frame(height: 220)
                .chartXAxis {
                    AxisMarks(values: points.map(\.hour)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(AppTheme.Colors.strokeSoft)
                        AxisValueLabel {
                            if let hour = value.as(Int.self) {
                                Text("\(hour)")
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(AppTheme.Colors.strokeSoft)
                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text("\(Int(amount))")
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct RecommendationSection: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionTitle(eyebrow: "Next Action", title: "下一步建议")
            GlassCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("保持热量赤字，不必再做复杂判断。")
                        .font(.headline)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Text(message)
                        .font(.body)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
        }
    }
}

#Preview {
    TodayView(snapshot: .placeholder)
}
