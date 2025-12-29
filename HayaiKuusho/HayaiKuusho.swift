//
//  HayaiKuusho.swift
//  HayaiKuusho
//
//  Created by Szymon Urbaniak on 18/12/2025.
//

import WidgetKit
import SwiftUI
import AppIntents

let appGroupID = "group.hexhyperion.Kuusho"

let faces = ["W", "X", "P", "O", "C", "S", "V", "3", "L", ")", "(", "/", ">", "*"]

func selectRandomFace() -> String {
    ":" + faces.randomElement()!
}

extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: appGroupID)!
}

struct CopyKuusho: AppIntent {
    static var title: LocalizedStringResource = "Copy Kuusho"
    static var description = IntentDescription("Copies the LTR mark to the user's clipboard.")
    
    func perform() async throws -> some IntentResult {
        #if os(macOS)
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString("Kuuuuusho test", forType: .string)
        #elseif os(iOS)
            let pasteboard = UIPasteboard.general
            pasteboard.string = "Kuuusho test iOS"
        #endif
        
        UserDefaults.appGroup.set(true, forKey: "copied")
        UserDefaults.appGroup.set(selectRandomFace(), forKey: "face")
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}

struct Provider: TimelineProvider {
    let copied = UserDefaults.appGroup.bool(forKey: "copied")
    let face = UserDefaults.appGroup.string(forKey: "face") ?? ":)"
    
    func placeholder(in context: Context) -> KuushoEntry {
        KuushoEntry(date: .now, copied: false, face: face)
    }

    func getSnapshot(in context: Context, completion: @escaping (KuushoEntry) -> ()) {
        completion(KuushoEntry(date: .now, copied: copied, face: face))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let copied = UserDefaults.appGroup.bool(forKey: "copied")
        let face = UserDefaults.appGroup.string(forKey: "face")!
        
        if (copied) {
            completion(Timeline(entries: [KuushoEntry(date: Date(), copied: true, face: face), KuushoEntry(date: Date(timeIntervalSinceNow: 1), copied: false, face: face)], policy: .never))
        }
        else {
            completion(Timeline(entries: [KuushoEntry(date: Date(), copied: false, face: face)], policy: .never))
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct KuushoEntry: TimelineEntry {
    let date: Date
    let copied: Bool
    let face: String
}

struct NoFeedbackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(nil, value: configuration.isPressed)
            .opacity(1)
    }
}

struct HayaiKuushoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Button(intent: CopyKuusho(), label: {
                Text(entry.copied ? ":D" : entry.face)
                    .font(.custom("SFMono-Regular", size: 110))
                    .fontDesign(.monospaced)
                    .foregroundStyle(entry.copied ? .green : .primary)
                    .contentTransition(.identity)
                    .kerning(-10)
                    .offset(x: -10, y: 0)
            })
            .buttonStyle(NoFeedbackButtonStyle())
        }
    }
}

struct HayaiKuusho: Widget {
    let kind: String = "HayaiKuusho"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, iOS 17.0, *) {
                HayaiKuushoEntryView(entry: entry)
                    .containerBackground(.clear, for: .widget)
            } else {
                HayaiKuushoEntryView(entry: entry)
                    .background()
            }
        }
        .configurationDisplayName("Hayai Kuusho")
        .description("A widget quickly providing you the magic \"void\" symbol!")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    HayaiKuusho()
} timeline: {
    KuushoEntry(date: .now, copied: false, face: ":)")
}
