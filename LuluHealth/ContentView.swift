//
//  ContentView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import SwiftUI

private enum AppSection: String, CaseIterable, Identifiable {
    case today
    case journey
    case log
    case insights
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: "Today"
        case .journey: "Journey"
        case .log: "Log"
        case .insights: "Insights"
        case .profile: "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .today: "flame.fill"
        case .journey: "figure.walk.motion"
        case .log: "plus.circle.fill"
        case .insights: "waveform.path.ecg"
        case .profile: "person.crop.circle"
        }
    }
}

struct ContentView: View {
    @State private var selection: AppSection = .today

    var body: some View {
        Group {
            #if os(macOS)
            desktopShell
            #else
            GeometryReader { proxy in
                if proxy.size.width >= 860 {
                    desktopShell
                } else {
                    compactShell
                }
            }
            #endif
        }
        .tint(AppTheme.Colors.energyCore)
        .preferredColorScheme(.dark)
    }

    private var compactShell: some View {
        TabView(selection: $selection) {
            ForEach(AppSection.allCases) { section in
                appSectionView(section)
                    .tag(section)
                    .tabItem {
                        Label(section.title, systemImage: section.systemImage)
                    }
            }
        }
    }

    private var desktopShell: some View {
        NavigationSplitView {
            AppSidebar(selection: $selection)
                .navigationTitle("LuluHealth")
        } detail: {
            appSectionView(selection)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(selection.title)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                    }
                }
        }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder
    private func appSectionView(_ section: AppSection) -> some View {
        switch section {
        case .today:
            TodayView(snapshot: TodayMockData.main)
        case .journey:
            JourneyView()
        case .log:
            LogView()
        case .insights:
            InsightsView()
        case .profile:
            ProfileView()
        }
    }
}

private struct AppSidebar: View {
    @Binding var selection: AppSection

    var body: some View {
        ZStack {
            AppBackground()

            List {
                ForEach(AppSection.allCases) { section in
                    Button {
                        selection = section
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: section.systemImage)
                                .frame(width: 18)
                            Text(section.title)
                        }
                        .foregroundStyle(selection == section ? AppTheme.Colors.textPrimary : AppTheme.Colors.textSecondary)
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(selection == section ? AppTheme.Colors.surfaceGlass : .clear)
                    )
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.sidebar)
        }
    }
}

#Preview {
    ContentView()
}
