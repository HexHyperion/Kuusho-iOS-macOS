//
//  SharedIntents.swift
//  Kuusho
//
//  Created by Szymon Urbaniak on 12/01/2026.
//

import Foundation
import AppIntents
import WidgetKit

public let appGroupID = "group.hexhyperion.Kuusho"
public let lastCopyKey = "lastCopyDate"
public let faceKey = "face"
public let copiedText = "\u{200E}"

public let faces = ["W", "P", "O", "V", "3", "L", ")", ">", "*"]

public func selectRandomFace(includeD: Bool = false) -> String {
    var tmpFaces = faces
    if includeD {
        tmpFaces.insert("D", at: 1)
    }
    return ":" + (tmpFaces.randomElement() ?? "P")
}

public extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: appGroupID)!
}

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct CopyKuusho: AppIntent {
    public static var title: LocalizedStringResource = "Copy Kuusho"
    public static var description = IntentDescription("Copy the LTR mark to clipboard.")

    public init() {}

    public func perform() -> some IntentResult {
        #if os(iOS)
        UIPasteboard.general.string = copiedText
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(copiedText, forType: .string)
        #endif

        UserDefaults.appGroup.set(Date(), forKey: lastCopyKey)
        UserDefaults.appGroup.set(selectRandomFace(), forKey: faceKey)

        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
