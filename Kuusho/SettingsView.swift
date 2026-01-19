//
//  SettingsView.swift
//  Kuusho
//
//  Created by Szymon Urbaniak on 12/01/2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Settings")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 400, minHeight: 350)
    }
}

#Preview {
    SettingsView()
}
