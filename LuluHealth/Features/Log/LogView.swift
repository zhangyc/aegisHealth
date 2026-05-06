//
//  LogView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

private struct LogFlowAction: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let icon: String
    let tint: Color
}

private let logActions = [
    LogFlowAction(title: "记饮食", detail: "让能量进入身体", icon: "leaf.fill", tint: AppTheme.Colors.intake),
    LogFlowAction(title: "记运动", detail: "让燃烧立刻上升", icon: "flame.fill", tint: AppTheme.Colors.energyCore),
    LogFlowAction(title: "记体重", detail: "校准长期趋势", icon: "figure.stand", tint: AppTheme.Colors.heatMagenta),
    LogFlowAction(title: "记状态", detail: "记录饥饿和疲劳", icon: "waveform.path.ecg", tint: AppTheme.Colors.deficit)
]

struct LogView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                LogHero()
                LogActionDeck()
                LogEnergyStream()
                LogCoachCard()
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
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                SectionTitle(eyebrow: "Log", title: "能量录入")
                Text("记录不是填表，而是把今天的能量流补完整。")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                HStack(spacing: AppTheme.Spacing.md) {
                    LogHeroPill(title: "已记录 4 次", tint: AppTheme.Colors.energyCore)
                    LogHeroPill(title: appModel.healthAccessState == .authorized ? "晚餐待补" : "等待 Health 授权", tint: AppTheme.Colors.heatMagenta)
                    LogHeroPill(title: appModel.hasTodayData ? "状态完整度 76%" : "今天还没成图", tint: AppTheme.Colors.intake)
                }
            }
        }
    }
}

private struct LogHeroPill: View {
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

private struct LogActionDeck: View {
    @EnvironmentObject private var appModel: AppModel
    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.md),
        GridItem(.flexible(), spacing: AppTheme.Spacing.md)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionTitle(eyebrow: "Quick Capture", title: "入口不是按钮，是语义")

            LazyVGrid(columns: columns, spacing: AppTheme.Spacing.md) {
                ForEach(logActions) { action in
                    Button {
                        switch action.title {
                        case "记饮食": appModel.openLogCapture(.intake)
                        case "记运动": appModel.openLogCapture(.workout)
                        case "记体重": appModel.openLogCapture(.weight)
                        default: appModel.openLogCapture(.status)
                        }
                    } label: {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(action.tint.opacity(0.16))
                                        .frame(width: 54, height: 54)
                                    Image(systemName: action.icon)
                                        .font(.title3.weight(.semibold))
                                        .foregroundStyle(action.tint)
                                }

                                Text(action.title)
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.Colors.textPrimary)

                                Text(action.detail)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.Colors.textSecondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct LogEnergyStream: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack {
                    Text("今日录入状态")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Spacer()
                    Text("No Entries Yet")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.textTertiary)
                }
                Text("这里不再伪造今天的录入流。等你真正写入饮食、运动或体重后，这里再显示真实时间线。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
    }
}

private struct LogCoachCard: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("系统提醒")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text("你今天最关键的缺口在晚餐后。补记晚餐，系统才能正确判断你现在是真的赤字，还是只是数据还没进来。")
                    .foregroundStyle(AppTheme.Colors.textSecondary)

                HStack(spacing: AppTheme.Spacing.md) {
                    Button {
                        appModel.openLogCapture(.intake)
                    } label: {
                        LogCTA(title: "补记晚餐", tint: AppTheme.Colors.energyCore)
                    }
                    .buttonStyle(.plain)

                    Button {
                    } label: {
                        LogCTA(title: "稍后提醒", tint: AppTheme.Colors.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct LogCTA: View {
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
                    .fill(tint.opacity(tint == AppTheme.Colors.textTertiary ? 0.10 : 0.18))
            )
            .frame(maxWidth: .infinity)
    }
}

struct LogCaptureSheet: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    let kind: LogCaptureKind
    @State private var primaryValue = ""
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(kind.helper)
                        .foregroundStyle(.secondary)
                } header: {
                    Text(kind.title)
                }

                Section("主要数值") {
                    TextField(placeholder, text: $primaryValue)
                        .keyboardType(.decimalPad)
                }

                Section("备注") {
                    TextField("可选", text: $note)
                }
            }
            .navigationTitle(kind.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        appModel.completeCapture()
                        dismiss()
                    }
                }
            }
        }
    }

    private var placeholder: String {
        switch kind {
        case .intake: "例如 620 kcal"
        case .workout: "例如 35 分钟"
        case .weight: "例如 78.3 kg"
        case .status: "例如 饥饿 3/5"
        }
    }
}

#Preview {
    LogView()
}
