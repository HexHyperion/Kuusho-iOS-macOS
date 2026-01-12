//
//  ContentView.swift
//  Kuusho
//
//  Created by Szymon Urbaniak on 17/12/2025.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    var body: some View {
        VStack {
            Button(intent: CopyKuusho()) {
                Text(":P")
                    .font(.custom("SFMono-Regular", size: 80))
                    .fontDesign(.monospaced)
                    .kerning(-10)
                    .offset(x: -10)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.roundedRectangle)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
