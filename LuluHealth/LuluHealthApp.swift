//
//  LuluHealthApp.swift
//  LuluHealth
//
//  Created by Zhangyc on 2026/5/6.
//

import SwiftUI

@main
struct LuluHealthApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
        }
    }
}
