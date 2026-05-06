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

extension TodaySnapshot {
    static let placeholder = TodaySnapshot(
        title: "Today",
        burnedCalories: 0,
        intakeCalories: 0,
        deficitCalories: 0,
        status: "No Data",
        projectedEndOfDay: 0,
        recommendation: "连接 Apple Health 或补一条记录，首页就会开始形成真实能量图。",
        metrics: [
            .init(title: "摄入", value: "--", tint: AppTheme.Colors.intake, detail: "等待今日数据"),
            .init(title: "燃烧", value: "--", tint: AppTheme.Colors.energyCore, detail: "等待今日数据"),
            .init(title: "赤字", value: "--", tint: AppTheme.Colors.deficit, detail: "等待今日数据"),
            .init(title: "今晚预测", value: "--", tint: AppTheme.Colors.energyWarm, detail: "等待今日数据")
        ],
        components: [],
        timeline: []
    )

    static func fromHealthData(_ data: HealthKitDailyData) -> TodaySnapshot {
        let totalBurn = Int(data.totalBurn.rounded())
        let intake = Int(data.dietaryEnergy.rounded())
        let deficit = Int(data.deficit.rounded())
        let workout = Int(data.workoutEnergy.rounded())
        let digestion = Int(data.digestionEnergy.rounded())
        let dailyActivity = max(Int(data.activeEnergy.rounded()) - workout, 0)
        let projected = deficit < 0 ? deficit - 80 : deficit + 80

        let totalComponents = max(data.totalBurn, 1)

        let points = stride(from: 0, to: max(data.hourlyBurn.count, data.hourlyIntake.count), by: 1).map { hour in
            TodaySnapshot.EnergyPoint(
                hour: hour,
                intake: hour < data.hourlyIntake.count ? data.hourlyIntake[hour] : 0,
                burn: hour < data.hourlyBurn.count ? data.hourlyBurn[hour] : 0
            )
        }

        return TodaySnapshot(
            title: "Today",
            burnedCalories: totalBurn,
            intakeCalories: intake,
            deficitCalories: deficit,
            status: deficit <= 0 ? "On track" : "Above target",
            projectedEndOfDay: projected,
            recommendation: deficit <= 0 ? "当前缺口在扩大，继续保持晚间活动节奏。" : "补一段步行或减少晚餐摄入，今晚还有机会回到赤字。",
            metrics: [
                .init(title: "摄入", value: "\(intake)", tint: AppTheme.Colors.intake, detail: "来自 Apple Health"),
                .init(title: "燃烧", value: "\(totalBurn)", tint: AppTheme.Colors.energyCore, detail: "基础代谢 + 活动 + 消化"),
                .init(title: "赤字", value: "\(deficit)", tint: deficit <= 0 ? AppTheme.Colors.deficit : AppTheme.Colors.surplus, detail: deficit <= 0 ? "当前处于缺口" : "当前处于积压"),
                .init(title: "今晚预测", value: "\(projected)", tint: AppTheme.Colors.energyWarm, detail: "按今天节奏估算")
            ],
            components: [
                .init(title: "基础代谢", calories: Int(data.basalEnergy.rounded()), share: data.basalEnergy / totalComponents, trend: "Health", tint: AppTheme.Colors.heatRed),
                .init(title: "消化消耗", calories: digestion, share: data.digestionEnergy / totalComponents, trend: "Estimate", tint: AppTheme.Colors.energyWarm),
                .init(title: "日常活动", calories: dailyActivity, share: Double(dailyActivity) / totalComponents, trend: "Health", tint: AppTheme.Colors.intake),
                .init(title: "运动燃烧", calories: workout, share: Double(workout) / totalComponents, trend: "Workout", tint: AppTheme.Colors.energyCore)
            ],
            timeline: points
        )
    }
}
