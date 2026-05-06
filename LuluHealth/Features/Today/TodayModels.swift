//
//  TodayModels.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import Foundation
import SwiftUI

struct TodaySnapshot {
    struct Metric: Identifiable {
        let id = UUID()
        let title: String
        let value: String
        let tint: Color
        let detail: String
    }

    struct BurnComponent: Identifiable {
        let id = UUID()
        let title: String
        let calories: Int
        let share: Double
        let trend: String
        let tint: Color
    }

    struct EnergyPoint: Identifiable {
        let id = UUID()
        let hour: Int
        let intake: Double
        let burn: Double
    }

    let title: String
    let burnedCalories: Int
    let intakeCalories: Int
    let deficitCalories: Int
    let status: String
    let projectedEndOfDay: Int
    let recommendation: String
    let metrics: [Metric]
    let components: [BurnComponent]
    let timeline: [EnergyPoint]
}

enum TodayMockData {
    static let main = TodaySnapshot(
        title: "Today",
        burnedCalories: 1_846,
        intakeCalories: 1_420,
        deficitCalories: 426,
        status: "On track",
        projectedEndOfDay: -518,
        recommendation: "再步行 22 分钟，今晚就能稳定进入 500 kcal 赤字。",
        metrics: [
            .init(title: "摄入", value: "1,420", tint: AppTheme.Colors.intake, detail: "午餐后平稳"),
            .init(title: "燃烧", value: "1,846", tint: AppTheme.Colors.energyCore, detail: "高于昨日 9%"),
            .init(title: "赤字", value: "-426", tint: AppTheme.Colors.deficit, detail: "接近目标区"),
            .init(title: "今晚预测", value: "-518", tint: AppTheme.Colors.energyWarm, detail: "如果保持当前节奏")
        ],
        components: [
            .init(title: "基础代谢", calories: 1_182, share: 0.64, trend: "+2%", tint: AppTheme.Colors.heatRed),
            .init(title: "消化消耗", calories: 138, share: 0.07, trend: "稳定", tint: AppTheme.Colors.energyWarm),
            .init(title: "日常活动", calories: 294, share: 0.16, trend: "+11%", tint: AppTheme.Colors.intake),
            .init(title: "运动燃烧", calories: 232, share: 0.13, trend: "+18%", tint: AppTheme.Colors.energyCore)
        ],
        timeline: [
            .init(hour: 6, intake: 0, burn: 90),
            .init(hour: 8, intake: 240, burn: 155),
            .init(hour: 10, intake: 120, burn: 170),
            .init(hour: 12, intake: 460, burn: 210),
            .init(hour: 14, intake: 80, burn: 165),
            .init(hour: 16, intake: 60, burn: 188),
            .init(hour: 18, intake: 390, burn: 225),
            .init(hour: 20, intake: 70, burn: 250),
            .init(hour: 22, intake: 0, burn: 195)
        ]
    )
}
