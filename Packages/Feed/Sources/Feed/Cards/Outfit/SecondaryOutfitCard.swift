//
//  SecondaryOutfitCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct SecondaryOutfitCard: View {
    static let estimatedHeight: CGFloat = 278
    static let estimatedPrimaryImageHeight: CGFloat = 238

    let outfit: FeedOutfit
    let imageService: ImageService
    @State var viewModel: CardViewModel

    init(outfit: FeedOutfit, imageService: ImageService) {
        self.outfit = outfit
        self.imageService = imageService
        self._viewModel = State(initialValue: CardViewModel(item: .outfit(id: outfit.id)))
    }

    var imageUrls: [URL] {
        let allUrls = [outfit.imgUrl].compactMap(\.self) + (outfit.products?.compactMap(\.imgUrl) ?? [])
        return [
            allUrls.first
        ].compactMap(\.self)
    }

    var body: some View {
        GenericItemCard(title: outfit.name, titleLineLimit: 1, subtitle: nil, imageUrls: imageUrls, estimatedPrimaryImageHeight: Self.estimatedPrimaryImageHeight, imageService: imageService, isBookmarked: viewModel.isBookmarked) {
            viewModel.toggleBookmark()
        }
    }
}

#Preview("Workday Uniform") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        SecondaryOutfitCard(outfit: .secondaryPreview, imageService: ImageService())
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}

#Preview("2 Products - Workday Uniform") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        SecondaryOutfitCard(outfit: .secondaryPreview2, imageService: ImageService())
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
