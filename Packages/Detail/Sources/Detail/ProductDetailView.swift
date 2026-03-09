//
//  ProductDetailView.swift
//  Detail
//
//  Created by Abdulaziz Albahar on 3/8/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

public struct ProductDetailView: View {
    private let product: FeedProduct
    private let imageService: ImageService

    public init(product: FeedProduct, imageService: ImageService) {
        self.product = product
        self.imageService = imageService
    }

    private var imageUrls: [URL] {
        if let imgUrl = product.imgUrl {
            return [imgUrl]
        }
        return []
    }

    public var body: some View {
        GenericDetailView(title: product.itemName, imageUrls: imageUrls, imageService: imageService) {
            Text(product.brand)
                .customFont(.Label.medium)
                .foregroundStyle(Color.Foreground.secondary)

            Text(product.price, format: .currency(code: "USD"))
                .customFont(.HeadingSans.xSmall)
                .foregroundStyle(Color.Content.primary)

            Link(destination: product.productUrl) {
                Text("View Product")
                    .customFont(.Label.small)
                    .foregroundStyle(.tint)
            }
        }
    }
}

#Preview("Detail Only") {
    FontManager.registerFonts()

    return NavigationStack {
        ProductDetailView(product: .primaryPreview, imageService: ImageService())
    }
}

#Preview("Card to Detail") {
    FontManager.registerFonts()

    struct CardToDetail: View {
        let product: FeedProduct = .primaryPreview
        @Namespace var namespace
        @State var selected: String?

        var body: some View {
            NavigationStack {
                Button { selected = product.id } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Background.secondary)
                        .frame(width: 180, height: 240)
                        .overlay { Text(product.itemName).customFont(.Label.small) }
                }
                .matchedTransitionSource(id: product.id, in: namespace)
                .navigationDestination(item: $selected) { _ in
                    ProductDetailView(product: product, imageService: ImageService())
                        .navigationTransition(.zoom(sourceID: product.id, in: namespace))
                }
            }
        }
    }

    return CardToDetail()
}
