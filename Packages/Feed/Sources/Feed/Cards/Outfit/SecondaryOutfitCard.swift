//
//  SecondaryOutfitCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI

struct SecondaryOutfitCard: View {
    static let estimatedHeight: CGFloat = 278
    static let estimatedPrimaryImageHeight: CGFloat = 238

    let outfit: FeedOutfit

    var imageUrls: [URL] {
        let allUrls = [outfit.imgUrl].compactMap(\.self) + (outfit.products?.compactMap(\.imgUrl) ?? [])
        return [
            allUrls.first
        ].compactMap(\.self)
    }

    var body: some View {
        GenericItemCard(title: outfit.name, titleLineLimit: 1, subtitle: nil, imageUrls: imageUrls, estimatedPrimaryImageHeight: Self.estimatedPrimaryImageHeight)
    }
}

#Preview("Workday Uniform") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        SecondaryOutfitCard(outfit: .secondaryPreview)
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}

#Preview("2 Products - Workday Uniform") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        SecondaryOutfitCard(outfit: .secondaryPreview2)
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
