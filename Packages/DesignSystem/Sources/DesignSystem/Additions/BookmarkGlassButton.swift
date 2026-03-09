//
//  BookmarkGlassButton.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI

public struct BookmarkGlassButton: View {
    let isBookmarked: Bool
    let action: () -> Void

    public init(isBookmarked: Bool, action: @escaping () -> Void) {
        self.isBookmarked = isBookmarked
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            if #available(iOS 26.0, *) {
                Image(isBookmarked ? .Custom.bookmarkSaved : .Custom.bookmarkNormal)
                    .frame(width: 32, height: 32)
            } else {
                Image(isBookmarked ? .Custom.bookmarkSaved : .Custom.legacyBookmarkNormal)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(8)
            }
        }
        .buttonStyle(.phiaGlass)
    }
}
