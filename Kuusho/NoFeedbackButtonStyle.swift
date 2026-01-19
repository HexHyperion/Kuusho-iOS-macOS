//
//  NoFeedbackButtonStyle.swift
//  Kuusho
//
//  Created by Szymon Urbaniak on 19/01/2026.
//

import SwiftUI

struct NoFeedbackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(nil, value: configuration.isPressed)
            .opacity(1)
    }
}
