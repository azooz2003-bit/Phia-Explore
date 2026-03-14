//
//  MasonryLayoutKeys.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/12/26.
//

import SwiftUI

public struct CanExpandVerticallyKey: LayoutValueKey, Sendable {
    nonisolated public static let defaultValue: Bool = true
}

public struct PrimaryImageFrameHeightKey: LayoutValueKey, Sendable {
    nonisolated public static let defaultValue: CGFloat? = nil
}

/// For debugging
public struct CardNameKey: LayoutValueKey, Sendable {
    nonisolated public static let defaultValue: String = ""
}

public extension View {
    func canExpandVertically(_ value: Bool) -> some View {
        layoutValue(key: CanExpandVerticallyKey.self, value: value)
    }

    func primaryImageFrameHeight(_ value: CGFloat?) -> some View {
        layoutValue(key: PrimaryImageFrameHeightKey.self, value: value)
    }

    /// For debugging
    func cardName(_ value: String) -> some View {
        layoutValue(key: CardNameKey.self, value: value)
    }
}
