//
//  PrimaryProductCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct PrimaryProductCard: View {
    static let estimatedHeight: CGFloat = 352
    static let estimatedPrimaryImageHeight: CGFloat = 270

    let product: FeedProduct
    let imageService: ImageService
    @State var viewModel: CardViewModel

    init(product: FeedProduct, imageService: ImageService) {
        self.product = product
        self.imageService = imageService
        self._viewModel = State(initialValue: CardViewModel(item: .product(id: product.id)))
    }

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    var priceFormatted: String? {
        formatter.string(for: product.price)
    }

    var body: some View {
        GenericItemCard(title: product.itemName, titleLineLimit: 2, imageUrls: [product.imgUrl].compactMap(\.self), estimatedPrimaryImageHeight: Self.estimatedPrimaryImageHeight, imageService: imageService, isBookmarked: viewModel.isBookmarked, onBookmarkToggle: { viewModel.toggleBookmark() }) {
            HStack(spacing: 0) {
                Text(product.brand.uppercased())
                    .lineLimit(1)
                    .layoutPriority(-1)

                if let priceFormatted {
                    Text(" • \(priceFormatted)")
                        .layoutPriority(1)
                }
            }
            .customFont(.CaptionMono.xSmall)
            .foregroundStyle(Color.Foreground.disabled)
        }
    }
}

#Preview {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        PrimaryProductCard(product: .primaryPreview, imageService: ImageService())
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}

#Preview("No image, no subtitle") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        GenericItemCard(title: "Ophidia mini bag", titleLineLimit: 2, subtitle: nil, imageUrls: nil, estimatedPrimaryImageHeight: PrimaryProductCard.estimatedPrimaryImageHeight, imageService: ImageService(), isBookmarked: false, onBookmarkToggle: {})
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}

#Preview("No image") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        PrimaryProductCard(product: .noImagePreview, imageService: ImageService())
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
