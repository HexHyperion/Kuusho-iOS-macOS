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
            ContentView()
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
