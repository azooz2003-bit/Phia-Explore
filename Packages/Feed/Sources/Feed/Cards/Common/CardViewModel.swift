//
//  CardViewModel.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/7/26.
//

import Foundation

@Observable
class CardViewModel {
    enum BookmarkedItem: Codable, Hashable {
        case outfit(id: String)
        case product(id: String)
        case editorial(id: String)
    }

    private static let userDefaultsKey = "bookmarkedItems"
    private let item: BookmarkedItem

    private(set) var isBookmarked: Bool

    init(item: BookmarkedItem) {
        self.item = item
        self.isBookmarked = Self.loadBookmarks().contains(item)
    }

    func toggleBookmark() {
        isBookmarked.toggle()
        var items = Self.loadBookmarks()
        if isBookmarked {
            items.insert(item)
        } else {
            items.remove(item)
        }
        guard let encoded = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
    }

    private static func loadBookmarks() -> Set<BookmarkedItem> {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let items = try? JSONDecoder().decode(Set<BookmarkedItem>.self, from: data) else {
            return []
        }
        return items
    }
}
