//
//  HayaiKuusho.swift
//  HayaiKuusho
//
//  Created by Szymon Urbaniak on 18/12/2025.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> KuushoEntry {
        KuushoEntry(date: .now, face: ":P")
    }

    func getSnapshot(in context: Context, completion: @escaping (KuushoEntry) -> ()) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<KuushoEntry>) -> ()) {
        if UserDefaults.appGroup.string(forKey: faceKey) == nil {
            UserDefaults.appGroup.set(selectRandomFace(), forKey: faceKey)
        }
        
        let now = Date()
        let entryNow = currentEntry(at: now)

        if let lastCopy = UserDefaults.appGroup.object(forKey: lastCopyKey) as? Date, now.timeIntervalSince(lastCopy) < 1 {
            let end = lastCopy.addingTimeInterval(1)
            let entryEnd = currentEntry(at: end)
            
            completion(Timeline(entries: [entryNow, entryEnd], policy: .atEnd))
        } else {
            completion(Timeline(entries: [entryNow], policy: .never))
        }
    }

    private func currentEntry(at date: Date = .now) -> KuushoEntry {
        let face = UserDefaults.appGroup.string(forKey: faceKey) ?? ":P"
        return KuushoEntry(date: date, face: face)
    }
}

struct KuushoEntry: TimelineEntry {
    let date: Date
    let face: String

    var isRecentlyCopied: Bool {
        guard let lastCopy = UserDefaults.appGroup.object(forKey: lastCopyKey) as? Date else {
            return false
        }
        return date.timeIntervalSince(lastCopy) < 1
    }
}

struct NoFeedbackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(nil, value: configuration.isPressed)
            .opacity(1)
    }
}

struct HayaiKuushoEntryView: View {
    var entry: KuushoEntry
    
    var body: some View {
        Button(intent: CopyKuusho()) {
            ZStack {
                Text(entry.isRecentlyCopied ? ":D" : entry.face)
                    .font(.custom("SFMono-Regular", size: 110))
                    .fontDesign(.monospaced)
                    .foregroundStyle(entry.isRecentlyCopied ? .green : .primary)
                    .kerning(-10)
                    .offset(x: -10)
                    .contentTransition(.identity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .buttonStyle(NoFeedbackButtonStyle())
        .contentMargins(.zero)
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
        .description("Quickly copy the magic \"void\" symbol (aka the LTR mark) to clipboard.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}


#Preview(as: .systemSmall, widget: {
    HayaiKuusho()
}, timeline: {
    let date = Date()
    KuushoEntry(date: date, face: ":P")
    KuushoEntry(date: date, face: ":)")
})
