//
//  SecondaryEditorialCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct SecondaryEditorialCard: View {
    static let estimatedHeight: CGFloat = 305
    static let estimatedPrimaryImageHeight: CGFloat = 241

    let editorial: FeedEditorial
    let imageService: ImageService

    var imageUrls: [URL] {
        [editorial.imgUrl].compactMap(\.self) + (editorial.products?.compactMap(\.imgUrl) ?? [])
    }

    var body: some View {
        VStack(spacing: 10) {
            visualContent

            footer
        }
        .background(Color.Background.primary)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    @ViewBuilder
    var visualContent: some View {
        HStack(spacing: 4) {
            primaryImage(for: imageUrls.first)

            VStack(spacing: 4) {
                let productImageUrls = Array(imageUrls.dropFirst().prefix(3))

                ForEach(productImageUrls.indices, id: \.self) { i in
                    productImage(for: productImageUrls[i])
                        .frame(maxHeight: .infinity)
                }

                if productImageUrls.count < 3 {
                    let spacesToAdd = 3 - productImageUrls.count
                    ForEach(0..<spacesToAdd, id: \.self) { _ in
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                }
            }
        }
        .padding([.leading, .trailing, .top], 4)
    }

    @ViewBuilder
    func primaryImage(for imgUrl: URL?) -> some View {
        if let imgUrl {
            Color.clear
                .frame(minHeight: Self.estimatedPrimaryImageHeight, maxHeight: .infinity)
                .overlay {
                    PhiaAsyncImage(url: imgUrl, estimatedHeight: Self.estimatedPrimaryImageHeight, imageService: imageService)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }

    @ViewBuilder
    func productImage(for imgUrl: URL) -> some View {
        PhiaAsyncImage(url: imgUrl, displayWidth: 40, imageService: imageService)
            .aspectRatio(contentMode: .fill)
            .frame(width: 40)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    @ViewBuilder
    var footer: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(editorial.title)
                    .customFont(.Label.medium)
                    .foregroundStyle(Color.Content.primary)
                    .lineLimit(2)
            }

            Spacer()

            Button {
                // Does nothing
            } label: {
                Image(.Custom.dotsThreeVertical)
                    .resizable()
                    .frame(width: 20, height: 20)
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading, .bottom], 10)
    }
}

#Preview("Single Product - Boyfriend's Closet") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        SecondaryEditorialCard(editorial: .secondaryPreview, imageService: ImageService())
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}

#Preview("3+ Products - Nike Air Force's Big Brother") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        SecondaryEditorialCard(editorial: .secondaryPreview2, imageService: ImageService())
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
