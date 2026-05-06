//
//  ProfileView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

private struct BodyMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let unit: String
    let tint: Color
}

private struct ProfileSetting: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let tint: Color
}

struct ProfileView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                ProfileHero()
                ProfileBodyPanel()
                ProfileSystemPanel()
                ProfileClosingCard()
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
            HStack(spacing: AppTheme.Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.surfaceGlass)
                        .frame(width: 84, height: 84)
                    Circle()
                        .stroke(AppTheme.Colors.strokeMedium, lineWidth: 1)
                        .frame(width: 84, height: 84)
                    Image(systemName: "figure.stand")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }

                VStack(alignment: .leading, spacing: 6) {
                    SectionTitle(eyebrow: "Profile", title: "身体模型")
                    Text("这里不是账号中心，而是你的代谢设定和目标边界。")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
        }
    }
}

private struct ProfileBodyPanel: View {
    @EnvironmentObject private var appModel: AppModel
    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.md),
        GridItem(.flexible(), spacing: AppTheme.Spacing.md)
    ]

    var body: some View {
        let dynamicMetrics = [
            BodyMetric(title: "身高", value: "178", unit: "cm", tint: AppTheme.Colors.intake),
            BodyMetric(title: "当前体重", value: "78.3", unit: "kg", tint: AppTheme.Colors.textPrimary),
            BodyMetric(title: "目标体重", value: String(format: "%.1f", appModel.preferences.targetWeight), unit: "kg", tint: AppTheme.Colors.deficit),
            BodyMetric(title: "每日目标赤字", value: "\(appModel.preferences.dailyDeficitGoal)", unit: "kcal", tint: AppTheme.Colors.energyCore)
        ]

        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionTitle(eyebrow: "Body", title: "身体基线")

            LazyVGrid(columns: columns, spacing: AppTheme.Spacing.md) {
                ForEach(dynamicMetrics) { metric in
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Circle()
                                .fill(metric.tint)
                                .frame(width: 10, height: 10)
                                .shadow(color: metric.tint.opacity(0.5), radius: 8)
                            Text(metric.title)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text(metric.value)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text(metric.unit)
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct ProfileSystemPanel: View {
    @EnvironmentObject private var appModel: AppModel
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("系统与偏好")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                ForEach(settings) { item in
                    HStack(spacing: AppTheme.Spacing.md) {
                        Circle()
                            .fill(item.tint)
                            .frame(width: 10, height: 10)
                        Text(item.title)
                            .font(.headline)
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Spacer()
                        Text(item.detail)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
    }

    private var settings: [ProfileSetting] {
        [
            ProfileSetting(title: "HealthKit", detail: appModel.healthAccessState == .authorized ? "已连接" : "未授权", tint: appModel.healthAccessState == .authorized ? AppTheme.Colors.deficit : AppTheme.Colors.heatMagenta),
            ProfileSetting(title: "Apple Watch", detail: "实时同步", tint: AppTheme.Colors.energyCore),
            ProfileSetting(title: "提醒节奏", detail: appModel.preferences.reminderStyle, tint: AppTheme.Colors.intake),
            ProfileSetting(title: "减脂策略", detail: appModel.preferences.weeklyPace, tint: AppTheme.Colors.heatMagenta)
        ]
    }
}

private struct ProfileClosingCard: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var isEditing = false

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("目标定义")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("你的目标不是单纯减重，而是让身体长期停留在可持续的能量缺口里。")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("这套参数会直接影响基础代谢估算、每日目标和提醒策略，所以它应该像仪表盘一样清楚，而不是像设置页一样无聊。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                Button {
                    isEditing = true
                } label: {
                    Text("调整目标与提醒")
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
        .sheet(isPresented: $isEditing) {
            PreferencesSheet()
        }
    }
}

private struct PreferencesSheet: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    @State private var targetWeight = 72.0
    @State private var dailyDeficit = 500.0
    @State private var weeklyPace = "温和减脂"
    @State private var reminderStyle = "午餐后 / 晚间"

    var body: some View {
        NavigationStack {
            Form {
                Section("目标") {
                    HStack {
                        Text("目标体重")
                        Spacer()
                        TextField("kg", value: $targetWeight, format: .number)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("每日赤字")
                        Spacer()
                        TextField("kcal", value: $dailyDeficit, format: .number)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("策略") {
                    TextField("减脂节奏", text: $weeklyPace)
                    TextField("提醒方式", text: $reminderStyle)
                }
            }
            .navigationTitle("目标设置")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        appModel.updatePreferences(
                            targetWeight: targetWeight,
                            dailyDeficitGoal: Int(dailyDeficit),
                            weeklyPace: weeklyPace,
                            reminderStyle: reminderStyle
                        )
                        dismiss()
                    }
                }
            }
            .onAppear {
                targetWeight = appModel.preferences.targetWeight
                dailyDeficit = Double(appModel.preferences.dailyDeficitGoal)
                weeklyPace = appModel.preferences.weeklyPace
                reminderStyle = appModel.preferences.reminderStyle
            }
        }
    }
}

#Preview {
    ProfileView()
}
