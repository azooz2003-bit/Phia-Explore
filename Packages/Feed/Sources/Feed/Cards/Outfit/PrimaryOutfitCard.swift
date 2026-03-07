//
//  PrimaryOutfitCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct PrimaryOutfitCard: View {
    static let estimatedHeight: CGFloat = 420
    static let estimatedPrimaryImageHeight: CGFloat = 380

    let outfit: FeedOutfit
    let imageService: ImageService

    var imageUrls: [URL] {
        let outfitImgUrl = [outfit.imgUrl].compactMap(\.self)
        let outfitProductsImgUrls = outfit.products?.compactMap(\.imgUrl) ?? []

        return outfitImgUrl + outfitProductsImgUrls
    }

    var body: some View {
        GenericItemCard(title: outfit.name, titleLineLimit: 1, subtitle: nil, imageUrls: imageUrls, estimatedPrimaryImageHeight: Self.estimatedPrimaryImageHeight, imageService: imageService)
    }
}

#Preview {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        PrimaryOutfitCard(outfit: .primaryPreview, imageService: ImageService())
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
