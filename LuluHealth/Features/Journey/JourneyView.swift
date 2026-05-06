//
//  JourneyView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

private struct JourneyPhase: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let state: String
    let tint: Color
    let isCurrent: Bool
}

struct JourneyView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                JourneyHero()
                JourneyNarrativeStrip()
                JourneyTrendState()
                JourneyPhaseTrack()
                JourneyPredictionCard()
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
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                SectionTitle(eyebrow: "Journey", title: "减脂旅程")

                HStack(alignment: .center, spacing: AppTheme.Spacing.lg) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("--")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Text("等连续体重数据累计后，这里才显示真实进度。")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }

                    Spacer()

                    JourneyOrbit(progress: appModel.hasTodayData ? 0.08 : 0)
                }

                HStack(spacing: AppTheme.Spacing.md) {
                    JourneyPulseMetric(title: "目标体重", value: String(format: "%.1f", appModel.preferences.targetWeight), suffix: "kg", tint: AppTheme.Colors.deficit)
                    JourneyPulseMetric(title: "赤字目标", value: "\(appModel.preferences.dailyDeficitGoal)", suffix: "kcal", tint: AppTheme.Colors.energyCore)
                    JourneyPulseMetric(title: "减脂节奏", value: appModel.preferences.weeklyPace == "温和减脂" ? "温和" : "自定", suffix: "", tint: AppTheme.Colors.intake)
                }
            }
        }
    }
}

private struct JourneyOrbit: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.Colors.strokeSoft, lineWidth: 12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            AppTheme.Colors.heatMagenta,
                            AppTheme.Colors.energyCore,
                            AppTheme.Colors.energyWarm
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 4) {
                Text(progress == 0 ? "--" : "\(Int(progress * 100))%")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("旅程进度")
                    .font(.caption)
                    .foregroundStyle(AppTheme.Colors.textTertiary)
            }
        }
        .frame(width: 124, height: 124)
    }
}

private struct JourneyPulseMetric: View {
    let title: String
    let value: String
    let suffix: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 999, style: .continuous)
                .fill(tint.opacity(0.9))
                .frame(width: 40, height: 5)
            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.Colors.textTertiary)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                if !suffix.isEmpty {
                    Text(suffix)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct JourneyNarrativeStrip: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("这不是体重曲线，而是你的能量路径。")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                HStack(spacing: AppTheme.Spacing.md) {
                    JourneyNarrativeChip(title: "Health", detail: appModel.healthAccessState == .authorized ? "已接入" : "未授权", tint: appModel.healthAccessState == .authorized ? AppTheme.Colors.deficit : AppTheme.Colors.heatMagenta)
                    JourneyNarrativeChip(title: "今日数据", detail: appModel.hasTodayData ? "已形成" : "等待中", tint: AppTheme.Colors.energyCore)
                    JourneyNarrativeChip(title: "提醒节奏", detail: appModel.preferences.reminderStyle, tint: AppTheme.Colors.intake)
                }
            }
        }
    }
}

private struct JourneyNarrativeChip: View {
    let title: String
    let detail: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Circle()
                .fill(tint)
                .frame(width: 10, height: 10)
                .shadow(color: tint.opacity(0.5), radius: 8)
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Text(detail)
                .font(.caption)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct JourneyTrendState: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack {
                    Text("长期趋势")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Spacer()
                    Text("No Trend Yet")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.textTertiary)
                }

                Text("现在还没有足够的连续体重样本。等接入更多天的数据后，这里才展示真实下降轨迹，而不是假图。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
    }
}

private struct JourneyPhaseTrack: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionTitle(eyebrow: "Phases", title: "阶段推进")

            ForEach(phases) { phase in
                GlassCard {
                    HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(phase.tint.opacity(phase.isCurrent ? 0.28 : 0.16))
                                .frame(width: 42, height: 42)
                            Circle()
                                .fill(phase.tint)
                                .frame(width: 12, height: 12)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(phase.title)
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Spacer()
                                Text(phase.state)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(phase.tint)
                            }
                            Text(phase.detail)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                        }
                    }
                }
            }
        }
    }

    private var phases: [JourneyPhase] {
        [
            JourneyPhase(title: "权限接入", detail: appModel.healthAccessState == .authorized ? "Apple Health 已连接。" : "先完成 Health 权限授权。", state: appModel.healthAccessState == .authorized ? "完成" : "待完成", tint: appModel.healthAccessState == .authorized ? AppTheme.Colors.deficit : AppTheme.Colors.heatMagenta, isCurrent: appModel.healthAccessState != .authorized),
            JourneyPhase(title: "样本积累", detail: appModel.hasTodayData ? "今天的数据已经进来，但长期趋势还不够。" : "等待更多连续天的数据。", state: appModel.hasTodayData ? "进行中" : "等待中", tint: AppTheme.Colors.energyCore, isCurrent: appModel.healthAccessState == .authorized),
            JourneyPhase(title: "真实预测", detail: "等有足够体重样本后，才给真正可用的长期预测。", state: "未开始", tint: AppTheme.Colors.intake, isCurrent: false)
        ]
    }
}

private struct JourneyPredictionCard: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("下一步")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("现在别相信任何长期预测，先把连续样本积起来。")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("先保证体重、饮食和运动数据稳定进入系统，旅程页之后再负责给真实判断。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Button {
                    appModel.openLogCapture(.weight)
                } label: {
                    Text("先补体重记录")
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
            }
        }
    }
}

#Preview {
    JourneyView()
}
