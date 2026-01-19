//
//  KuushoApp.swift
//  Kuusho
//
//  Created by Szymon Urbaniak on 17/12/2025.
//

import SwiftUI

@main
struct KuushoApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            TabView {
                ContentView()
                    .tabItem { Label("Home", systemImage: "house") }

                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            #elseif os(macOS)
            ContentView()
            #endif
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
