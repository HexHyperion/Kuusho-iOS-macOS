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
        
        
        UserDefaults.appGroup.set(!UserDefaults.appGroup.bool(forKey: "copied"), forKey: "copied")
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> KuushoEntry {
        KuushoEntry(date: .now, copied: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (KuushoEntry) -> ()) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [makeEntry()], policy: .never))
    }
    
    private func makeEntry() -> KuushoEntry {
        let copied = UserDefaults.appGroup.bool(forKey: "copied")
        return KuushoEntry(date: Date(), copied: copied)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct KuushoEntry: TimelineEntry {
    let date: Date
    let copied: Bool
}

struct NoFeedbackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(.bouncy, value: configuration.isPressed)
            .opacity(1)
    }
}

struct HayaiKuushoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Button(intent: CopyKuusho(), label: {
                Text(entry.copied ? ":D" : ":)")
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
    }
}

#Preview(as: .systemSmall) {
    HayaiKuusho()
} timeline: {
    KuushoEntry(date: .now, copied: false)
}
