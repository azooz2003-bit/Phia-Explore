//
//  Color+Custom.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI

public extension Color {
    enum Content {
        public static let primary = Color(.contentPrimary)
        public static let negative = Color(.contentNegative)
    }

    enum Foreground {
        public static let primary = Color(.foregroundPrimary)
        public static let secondary = Color(.foregroundSecondary)
        public static let tertiary = Color(.foregroundTertiary)
        public static let disabled = Color(.foregroundDisabled)
        public static let inverse = Color(.foregroundInverse)
    }

    enum Background {
        public static let primary = Color(.backgroundPrimary)
        public static let secondary = Color(.backgroundSecondary)
        public static let tertiary = Color(.backgroundTertiary)
    }

    enum Overlay {
        public static let light950 = Color(.overlayLight950)
        public static let dark500 = Color(.overlayDark500)
    }
}
