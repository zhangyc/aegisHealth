//
//  ProfileView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                ProfileHero()
                ProfileBodyStats()
                ProfileConnections()
                ProfileGoals()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.top, AppTheme.Spacing.md)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
    }
}

private struct ProfileHero: View {
    var body: some View {
        GlassCard {
            HStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.surfaceGlass)
                        .frame(width: 72, height: 72)
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    SectionTitle(eyebrow: "Profile", title: "身体参数")
                    Text("你的代谢模型和目标设定都在这里。")
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
        }
    }
}

private struct ProfileBodyStats: View {
    private let stats = [
        ("身高", "178", "cm"),
        ("当前体重", "78.3", "kg"),
        ("目标体重", "72.0", "kg"),
        ("年龄", "29", "岁")
    ]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.md) {
            ForEach(stats, id: \.0) { stat in
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(stat.0)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(stat.1)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            Text(stat.2)
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                        }
                    }
                }
            }
        }
    }
}

private struct ProfileConnections: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("数据连接")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                ProfileRow(title: "HealthKit", detail: "已连接", tint: AppTheme.Colors.deficit)
                ProfileRow(title: "Apple Watch", detail: "同步中", tint: AppTheme.Colors.energyCore)
                ProfileRow(title: "静息消耗估算", detail: "自动计算", tint: AppTheme.Colors.intake)
            }
        }
    }
}

private struct ProfileGoals: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("目标与偏好")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                ProfileRow(title: "每日目标赤字", detail: "500 kcal", tint: AppTheme.Colors.heatMagenta)
                ProfileRow(title: "优先策略", detail: "控制晚餐 + 固定步行", tint: AppTheme.Colors.deficit)
                ProfileRow(title: "提醒节奏", detail: "午餐后 / 晚间", tint: AppTheme.Colors.energyCore)
            }
        }
    }
}

private struct ProfileRow: View {
    let title: String
    let detail: String
    let tint: Color

    var body: some View {
        HStack {
            Circle()
                .fill(tint)
                .frame(width: 10, height: 10)
            Text(title)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
            Text(detail)
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }
}

#Preview {
    ProfileView()
}
