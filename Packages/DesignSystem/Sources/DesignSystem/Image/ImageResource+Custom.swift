//
//  ImageResource+Custom.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI

public extension ImageResource {
    enum Custom {
        public static let verifiedCheckmark = ImageResource(name: "verifiedCheckmark", bundle: .module)
        public static let logoWhite = ImageResource(name: "logoWhite", bundle: .module)
        public static let bell = ImageResource(name: "bell", bundle: .module)
        public static let bookmarkNormal = ImageResource(name: "bookmarkNormal", bundle: .module)
        public static let bookmarkSaved = ImageResource(name: "bookmarkSaved", bundle: .module)
        public static let legacyBookmarkNormal = ImageResource(name: "legacyBookmark", bundle: .module)
        public static let dotsThreeVertical = ImageResource(name: "dotsThreeVertical", bundle: .module)
    }
}
