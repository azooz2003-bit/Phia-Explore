//
//  ProductsRow.swift
//  Detail
//
//  Created by Abdulaziz Albahar on 3/8/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct ProductsRow: View {
    let products: [FeedProduct]
    let imageService: ImageService

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()

            Text("Products")
                .customFont(.Label.medium)
                .foregroundStyle(Color.Content.primary)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(products, id: \.id) { product in
                        productCard(product)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    private func productCard(_ product: FeedProduct) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if let imgUrl = product.imgUrl {
                PhiaAsyncImage(url: imgUrl, imageService: imageService)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.Background.secondary)
                    .frame(width: 120, height: 150)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(Color.Foreground.disabled)
                    }
            }

            Text(product.brand.uppercased())
                .customFont(.CaptionMono.xSmall)
                .foregroundStyle(Color.Foreground.disabled)
                .lineLimit(1)

            Text(product.itemName)
                .customFont(.Label.small)
                .foregroundStyle(Color.Content.primary)
                .lineLimit(1)

            Text(product.price, format: .currency(code: "USD"))
                .customFont(.CaptionMono.xSmall)
                .foregroundStyle(Color.Foreground.disabled)
        }
        .frame(width: 120)
    }
}
