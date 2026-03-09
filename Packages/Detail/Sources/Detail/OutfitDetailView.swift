//
//  OutfitDetailView.swift
//  Detail
//
//  Created by Abdulaziz Albahar on 3/8/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

public struct OutfitDetailView: View {
    private let outfit: FeedOutfit
    private let imageService: ImageService

    public init(outfit: FeedOutfit, imageService: ImageService) {
        self.outfit = outfit
        self.imageService = imageService
    }

    private var imageUrls: [URL] {
        if let imgUrls = outfit.imgUrls, !imgUrls.isEmpty {
            return imgUrls
        } else if let imgUrl = outfit.imgUrl {
            return [imgUrl]
        }
        return []
    }

    public var body: some View {
        GenericDetailView(title: outfit.name, imageUrls: imageUrls, brand: outfit.brand, products: outfit.products, imageService: imageService) {
            if let description = outfit.description {
                Text(description)
                    .customFont(.ParagraphEditorial.medium)
                    .foregroundStyle(Color.Foreground.secondary)
            }
        }
    }
}

#Preview("Detail Only") {
    FontManager.registerFonts()

    return NavigationStack {
        OutfitDetailView(outfit: .primaryPreview, imageService: ImageService())
    }
}

#Preview("Card to Detail") {
    FontManager.registerFonts()

    struct CardToDetail: View {
        let outfit: FeedOutfit = .primaryPreview
        @Namespace var namespace
        @State var selected: String?

        var body: some View {
            NavigationStack {
                Button { selected = outfit.id } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Background.secondary)
                        .frame(width: 180, height: 240)
                        .overlay { Text(outfit.name).customFont(.Label.small) }
                }
                .matchedTransitionSource(id: outfit.id, in: namespace)
                .navigationDestination(item: $selected) { _ in
                    OutfitDetailView(outfit: outfit, imageService: ImageService())
                        .navigationTransition(.zoom(sourceID: outfit.id, in: namespace))
                }
            }
        }
    }

    return CardToDetail()
}
