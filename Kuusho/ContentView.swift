//
//  ContentView.swift
//  Kuusho
//
//  Created by Szymon Urbaniak on 17/12/2025.
//

import SwiftUI
import AppIntents

let backgroundFaceSize: CGFloat = 36.0

struct FaceText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("SFMono-Regular", size: backgroundFaceSize))
            .fontDesign(.monospaced)
            .foregroundStyle(.gray.opacity(0.5))
            .kerning(-2)
            .offset(x: -2, y: 0)
            .fixedSize()
    }
}

struct FaceColumn: View {
    @State private var offset: CGSize = .zero
    let areaSize: CGSize
    
    var animation: Animation {
        Animation
            .linear(duration: 2)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        VStack {
            ForEach(0..<Int(areaSize.height.rounded(.up) / calculateFaceDimensions().height) + 1, id: \.self) { num in
                FaceText(text: selectRandomFace(includeD: true))
            }
        }
        .offset(offset)
        .onAppear() {
            withAnimation(animation) {
                self.offset.height += calculateFaceDimensions().height
            }
        }
    }
    
    func calculateFaceDimensions() -> CGRect {
        #if os(macOS)
        let font = NSFont.monospacedSystemFont(ofSize: backgroundFaceSize, weight: .regular)
        #elseif os(iOS)
        let font = UIFont.monospacedSystemFont(ofSize: backgroundFaceSize, weight: .regular)
        #endif
        
        return NSAttributedString(
            string: ":P",
            attributes: [
                .font: font
            ]
        ).getDimensions()
    }
}

struct FaceBackground: View {
    let areaSize: CGSize
    
    var body: some View {
        HStack (spacing: 5, content: {
            ForEach(0..<Int(areaSize.width.rounded(.up) / calculateColumnWidth() + 1), id: \.self) { num in
                FaceColumn(areaSize: areaSize)
            }
        })
    }
    
    func calculateColumnWidth() -> CGFloat {
        FaceColumn(areaSize: areaSize).calculateFaceDimensions().width
    }
}

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            let areaSize = geometry.size
            ZStack {
                FaceBackground(areaSize: areaSize)
                
                VStack {
                    Button(intent: CopyKuusho()) {
                        Text(":P")
                            .font(.custom("SFMono-Regular", size: 80))
                            .fontDesign(.monospaced)
                            .kerning(-10)
                            .offset(x: -10)
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.roundedRectangle)
                }
            }
            .frame(minWidth: 400, minHeight: 350)
        }
        .frame(minWidth: 400, minHeight: 350)
    }
}

extension NSAttributedString {
    func getDimensions() -> CGRect {
        let size = CGSize(width: CoreFoundation.CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return boundingBox
    }
}

#Preview {
    ContentView()
}

