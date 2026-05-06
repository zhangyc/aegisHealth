//
//  AppTheme.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

enum AppTheme {
    enum Colors {
        static let backgroundPrimary = Color(hex: 0x0B1020)
        static let backgroundSecondary = Color(hex: 0x12192C)
        static let backgroundTertiary = Color(hex: 0x1B2338)
        static let surfaceCard = Color(hex: 0x10182A)
        static let surfaceElevated = Color(hex: 0x16213A)
        static let surfaceGlass = Color.white.opacity(0.08)
        static let strokeSoft = Color.white.opacity(0.08)
        static let strokeMedium = Color.white.opacity(0.15)
        static let textPrimary = Color(hex: 0xF5F7FF)
        static let textSecondary = Color(hex: 0xB7C0D9)
        static let textTertiary = Color(hex: 0x7F89A8)
        static let energyCore = Color(hex: 0xFF7A1A)
        static let energyHot = Color(hex: 0xFF9F0A)
        static let energyWarm = Color(hex: 0xFFB84D)
        static let heatRed = Color(hex: 0xFF5E57)
        static let heatMagenta = Color(hex: 0xFF4FCB)
        static let intake = Color(hex: 0x64D2FF)
        static let deficit = Color(hex: 0x32D17C)
        static let surplus = Color(hex: 0xFFB020)
    }

    enum Gradients {
        static let appBackground = LinearGradient(
            colors: [
                Color(hex: 0x09101F),
                Color(hex: 0x141B31),
                Color(hex: 0x0E1324)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let bodyCore = LinearGradient(
            colors: [
                Colors.heatRed,
                Colors.energyCore,
                Color(hex: 0xFFD166)
            ],
            startPoint: .top,
            endPoint: .bottom
        )

        static let energyStream = LinearGradient(
            colors: [
                Colors.heatMagenta,
                Colors.energyCore,
                Color(hex: 0xFFE08A)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    enum Radius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 18
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }

    enum Spacing {
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }
}

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
