//
//  BookmarkGlass.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import DesignSystem

struct BookmarkGlass: View {
    let isBookmarked: Bool

    var body: some View {
        Group {
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
        .phiaGlass()
    }
}

#Preview("Phia Glass") {
    RoundedRectangle(cornerRadius: 12)
        .fill(.blue)
        .overlay {
            VStack {
                Button {
                    print("Pressed")
                } label: {
                    BookmarkGlass(isBookmarked: true)
                }
            }
        }
}
