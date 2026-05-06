//
//  InsightsView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                InsightsHero()
                InsightsDataState()
                InsightsSignalState()
                InsightWindowCard()
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
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                SectionTitle(eyebrow: "Insights", title: "代谢洞察")
                Text("洞察必须建立在真实样本上，不然只是漂亮的猜测。")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                HStack(spacing: AppTheme.Spacing.md) {
                    InsightHeroTag(title: appModel.healthAccessState == .authorized ? "Health 已接入" : "先授权 Health", tint: appModel.healthAccessState == .authorized ? AppTheme.Colors.deficit : AppTheme.Colors.heatMagenta)
                    InsightHeroTag(title: appModel.hasTodayData ? "今日数据已进入" : "今天还没有足够样本", tint: AppTheme.Colors.energyCore)
                }
            }
        }
    }
}

private struct InsightHeroTag: View {
    let title: String
    let tint: Color

    var body: some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(AppTheme.Colors.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(tint.opacity(0.16))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(tint.opacity(0.22), lineWidth: 1)
                    )
            )
    }
}

private struct InsightsDataState: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("摄入与燃烧交汇")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("现在还没有足够的连续样本去判断你的真实交汇点。这里之后会基于小时级摄入和燃烧，给出真正可用的时间窗口。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
    }
}

private struct InsightsSignalState: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionTitle(eyebrow: "Signals", title: "当前缺的不是结论，是样本")

            ForEach(signals, id: \.0) { item in
                GlassCard {
                    HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                        RoundedRectangle(cornerRadius: 999, style: .continuous)
                            .fill(item.1)
                            .frame(width: 5)
                        Text(item.0)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
    }

    private var signals: [(String, Color)] {
        [
            (appModel.healthAccessState == .authorized ? "Health 权限已经接通，下一步要等更多真实样本进入。" : "先连上 Apple Health，不然洞察页没有任何真实基础。", AppTheme.Colors.heatMagenta),
            ("至少要有连续的摄入、燃烧和体重记录，这里才配给结论。", AppTheme.Colors.energyCore),
            ("在那之前，这页宁可空着，也不再拿假图假结论糊弄。", AppTheme.Colors.intake)
        ]
    }
}

private struct InsightWindowCard: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("下一步")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("先补真实训练或饮食记录。")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("洞察页应该从真实行为里长出来，而不是从假数据里画出来。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                Button {
                    appModel.openLogCapture(.workout)
                } label: {
                    Text("去补训练记录")
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
    InsightsView()
}
