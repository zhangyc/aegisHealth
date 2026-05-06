//
//  LogView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

struct LogView: View {
    private let quickActions = [
        ("加餐", "fork.knife", AppTheme.Colors.intake),
        ("运动", "figure.run", AppTheme.Colors.energyCore),
        ("体重", "scalemass", AppTheme.Colors.heatMagenta),
        ("喝水", "drop.fill", AppTheme.Colors.deficit)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                LogHero()
                LogQuickActions(actions: quickActions)
                LogRecentEntries()
                LogSmartSuggestions()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.md)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
    }
}

private struct LogHero: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                SectionTitle(eyebrow: "Log", title: "快速记录")
                Text("把摄入、运动、体重做成 3 秒输入，而不是复杂表单。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                HStack(spacing: AppTheme.Spacing.md) {
                    LogPill(title: "已记录 4 次", tint: AppTheme.Colors.energyCore)
                    LogPill(title: "晚餐未录入", tint: AppTheme.Colors.heatMagenta)
                }
            }
        }
    }
}

private struct LogQuickActions: View {
    let actions: [(String, String, Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("快速入口")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.md) {
                ForEach(actions, id: \.0) { action in
                    GlassCard {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(action.2.opacity(0.18))
                                    .frame(width: 48, height: 48)
                                Image(systemName: action.1)
                                    .font(.title3)
                                    .foregroundStyle(action.2)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(action.0)
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text("点按即记")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }

                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

private struct LogRecentEntries: View {
    private let entries = [
        ("18:40", "晚间快走", "232 kcal", AppTheme.Colors.energyCore),
        ("13:10", "午餐", "620 kcal", AppTheme.Colors.intake),
        ("08:05", "体重", "78.3 kg", AppTheme.Colors.heatMagenta),
        ("07:40", "早餐", "418 kcal", AppTheme.Colors.intake)
    ]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("最近记录")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                ForEach(entries, id: \.0) { entry in
                    HStack {
                        Text(entry.0)
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                            .frame(width: 56, alignment: .leading)
                        Circle()
                            .fill(entry.3)
                            .frame(width: 8, height: 8)
                        Text(entry.1)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Spacer()
                        Text(entry.2)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
    }
}

private struct LogSmartSuggestions: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("智能建议")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("你今天的摄入记录主要集中在白天，建议补记晚餐后，赤字预测会更准确。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Button {
                } label: {
                    Text("补记晚餐")
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

private struct LogPill: View {
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
            )
    }
}

#Preview {
    LogView()
}
