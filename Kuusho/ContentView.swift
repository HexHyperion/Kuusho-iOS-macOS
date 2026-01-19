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
            .foregroundStyle(.gray.opacity(0.2))
            .kerning(-2)
            .offset(x: -2, y: 0)
            .fixedSize()
    }
}

struct FaceColumn: View {
    let areaSize: CGSize
    
    var body: some View {
        VStack {
            ForEach(0..<Int(areaSize.height.rounded(.up) / calculateFaceDimensions().height) + 1, id: \.self) { num in
                FaceText(text: selectRandomFace(includeD: true))
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
    @State private var tint = Color.primary
    @State private var face = selectRandomFace()
    
    var body: some View {
        GeometryReader { geometry in
            let areaSize = geometry.size
            ZStack {
                FaceBackground(areaSize: areaSize)

                VStack(spacing: 0) {
                    Text("Kūsho")
                        .font(.custom("Bradley Hand", size: 80))
                    
                    Button(action: {
                        withAnimation(nil) {
                            _ = CopyKuusho().perform()
                            self.tint = .green
                            self.face = ":D"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.tint = .primary
                                self.face = selectRandomFace()
                            }
                        }
                    }, label: {
                        Text(self.face)
                            .font(.custom("SFMono-Regular", size: 140))
                            .fontDesign(.monospaced)
                            .kerning(-10)
                            .offset(x: -12)
                            .padding(12)
                            .contentTransition(.identity)
                    })
                    .buttonStyle(.glass)
                    #if os(macOS)
                    .cornerRadius(40)
                    .foregroundStyle(self.tint)
                    #elseif os(iOS)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(self.tint)
                    #endif
                    .contentTransition(.identity)
                }
            }
            .frame(minWidth: 400, minHeight: 350)
        }
        .frame(minWidth: 400, minHeight: 350)
        .ignoresSafeArea()
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

