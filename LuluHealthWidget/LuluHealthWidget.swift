//
//  LuluHealthWidget.swift
//  LuluHealthWidget
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI
import WidgetKit

private enum WidgetTheme {
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

private struct EnergyWidgetEntry: TimelineEntry {
    let date: Date
    let burned: Int
    let intake: Int
    let balance: Int
    let goalProgress: Double
    let nextStep: String
}

private struct EnergyWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> EnergyWidgetEntry {
        .mock
    }

    func getSnapshot(in context: Context, completion: @escaping (EnergyWidgetEntry) -> Void) {
        completion(.mock)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EnergyWidgetEntry>) -> Void) {
        let now = Date()
        let entries = stride(from: 0, through: 4, by: 1).map { hourOffset in
            EnergyWidgetEntry(
                date: Calendar.current.date(byAdding: .hour, value: hourOffset, to: now) ?? now,
                burned: 2_346,
                intake: 1_842,
                balance: -504,
                goalProgress: 0.78,
                nextStep: "再走 18 分钟，今晚赤字会更稳。"
            )
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

private extension EnergyWidgetEntry {
    static let mock = EnergyWidgetEntry(
        date: .now,
        burned: 2_346,
        intake: 1_842,
        balance: -504,
        goalProgress: 0.78,
        nextStep: "再走 18 分钟，今晚赤字会更稳。"
    )

    var balanceTitle: String {
        balance < 0 ? "能量缺口" : "能量积压"
    }

    var balanceColor: Color {
        balance < 0 ? WidgetTheme.deficit : WidgetTheme.energy
    }

    var balanceDescription: String {
        balance < 0 ? "你今天还在稳定赤字区间。" : "你今天已经进入热量盈余。"
    }
}

private struct LuluHealthWidgetEntryView: View {
    var entry: EnergyWidgetProvider.Entry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemMedium:
            mediumView
        default:
            smallView
        }
    }

    private var smallView: some View {
        ZStack {
            WidgetBackground()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(entry.balanceTitle)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(entry.balanceColor)
                    Spacer()
                    MiniRing(progress: entry.goalProgress)
                }

                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text("\(abs(entry.balance))")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(WidgetTheme.textPrimary)
                    Text("kcal")
                        .font(.caption)
                        .foregroundStyle(WidgetTheme.textSecondary)
                }

                EnergyBand()
                    .frame(height: 42)

                HStack(spacing: 8) {
                    metricChip(title: "摄入", value: entry.intake, tint: WidgetTheme.intake)
                    metricChip(title: "燃烧", value: entry.burned, tint: WidgetTheme.energy)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private var mediumView: some View {
        ZStack {
            WidgetBackground()

            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(entry.balanceTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(entry.balanceColor)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(abs(entry.balance))")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(WidgetTheme.textPrimary)
                        Text("kcal")
                            .font(.headline)
                            .foregroundStyle(WidgetTheme.textSecondary)
                    }

                    Text(entry.balanceDescription)
                        .font(.caption)
                        .foregroundStyle(WidgetTheme.textSecondary)

                    EnergyBand()
                        .frame(height: 46)

                    Text(entry.nextStep)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(WidgetTheme.textPrimary)
                        .lineLimit(2)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(WidgetTheme.glass)
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(WidgetTheme.stroke, lineWidth: 1)
                                )
                        )
                }

                VStack(alignment: .trailing, spacing: 12) {
                    LargeRing(progress: entry.goalProgress)
                    metricChip(title: "摄入", value: entry.intake, tint: WidgetTheme.intake)
                    metricChip(title: "燃烧", value: entry.burned, tint: WidgetTheme.energy)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func metricChip(title: String, value: Int, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(WidgetTheme.textTertiary)
            Text("\(value)")
                .font(.caption.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(WidgetTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(tint.opacity(0.18), lineWidth: 1)
                )
        )
    }
}

private struct WidgetBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [WidgetTheme.bgTop, WidgetTheme.bgMid, WidgetTheme.bgBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(WidgetTheme.energy.opacity(0.18))
                .frame(width: 120, height: 120)
                .blur(radius: 34)
                .offset(x: 56, y: -30)

            Circle()
                .fill(WidgetTheme.intake.opacity(0.10))
                .frame(width: 110, height: 110)
                .blur(radius: 32)
                .offset(x: -60, y: 66)
        }
    }
}

private struct EnergyBand: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )

            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            WidgetTheme.intake.opacity(0.20),
                            WidgetTheme.energy.opacity(0.80),
                            WidgetTheme.warm.opacity(0.95)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .blur(radius: 2)
                .padding(.horizontal, 8)
                .padding(.vertical, 12)

            HStack(spacing: 10) {
                GlowDot(color: WidgetTheme.intake, size: 8)
                GlowDot(color: WidgetTheme.energy, size: 12)
                GlowDot(color: WidgetTheme.warm, size: 8)
            }
        }
    }
}

private struct GlowDot: View {
    let color: Color
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .shadow(color: color.opacity(0.6), radius: 7)
    }
}

private struct MiniRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.10), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [WidgetTheme.warm, WidgetTheme.energy, Color(red: 1.0, green: 0.35, blue: 0.30)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 28, height: 28)
    }
}

private struct LargeRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.10), lineWidth: 10)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [WidgetTheme.warm, WidgetTheme.energy, Color(red: 1.0, green: 0.35, blue: 0.30)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(Int(progress * 100))%")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(WidgetTheme.textPrimary)
                Text("goal")
                    .font(.caption2)
                    .foregroundStyle(WidgetTheme.textTertiary)
            }
        }
        .frame(width: 88, height: 88)
    }
}

struct LuluHealthWidget: Widget {
    let kind: String = "LuluHealthWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EnergyWidgetProvider()) { entry in
            LuluHealthWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Energy Balance")
        .description("显示当前是热量积压还是缺口，并提醒下一步。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    LuluHealthWidget()
} timeline: {
    EnergyWidgetEntry.mock
}

#Preview(as: .systemMedium) {
    LuluHealthWidget()
} timeline: {
    EnergyWidgetEntry.mock
}
