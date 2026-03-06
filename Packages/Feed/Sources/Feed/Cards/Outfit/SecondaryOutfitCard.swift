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
    let outfit: FeedOutfit

    var body: some View {
        GenericItemCard(title: outfit.name, titleLineLimit: 1, subtitle: nil, imageUrls: [outfit.imgUrl].compactMap(\.self))
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
