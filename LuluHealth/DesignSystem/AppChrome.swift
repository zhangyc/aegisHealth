//
//  AppChrome.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            AppTheme.Gradients.appBackground
            Circle()
                .fill(AppTheme.Colors.heatMagenta.opacity(0.18))
                .blur(radius: 120)
                .frame(width: 220, height: 220)
                .offset(x: -120, y: -280)
            Circle()
                .fill(AppTheme.Colors.energyCore.opacity(0.16))
                .blur(radius: 120)
                .frame(width: 260, height: 260)
                .offset(x: 120, y: -40)
            Circle()
                .fill(AppTheme.Colors.intake.opacity(0.10))
                .blur(radius: 120)
                .frame(width: 280, height: 280)
                .offset(x: 0, y: 320)
        }
        .ignoresSafeArea()
    }
}

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.large, style: .continuous)
                    .fill(AppTheme.Colors.surfaceGlass)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.large, style: .continuous)
                            .stroke(AppTheme.Colors.strokeSoft, lineWidth: 1)
                    )
            )
    }
}

struct SectionTitle: View {
    let eyebrow: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(eyebrow.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
        }
    }
}
