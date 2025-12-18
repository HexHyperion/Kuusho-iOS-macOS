//
//  ContentView.swift
//  Kuusho
//
//  Created by Szymon Urbaniak on 17/12/2025.
//

import SwiftUI

func test() {
    #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString("Kuuuuusho test", forType: .string)
    #elseif os(iOS)
        let pasteboard = UIPasteboard.general
        pasteboard.string = "Kuuusho test iOS"
    #endif
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button(action: test) {
                Text("hejka")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
