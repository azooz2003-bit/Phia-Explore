//
//  SecondaryEditorialCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI

struct SecondaryEditorialCard: View {
    static let estimatedHeight: CGFloat = 305
    static let estimatedPrimaryImageHeight: CGFloat = 241

    let editorial: FeedEditorial
    
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
            primaryImage(for: editorial.imgUrl)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 4) {
                let products = editorial.products ?? []

                ForEach(products.prefix(3), id: \.id) { product in
                    productImage(for: product.imgUrl)
                        .frame(maxHeight: .infinity)
                }

                if products.count < 3 {
                    // Add space blocks to preserve product image size
                    let spacesToAdd = 3 - products.count
                    ForEach(0..<spacesToAdd, id: \.self) { _ in
                        Spacer()
                            .frame(maxHeight: .infinity)
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding([.leading, .trailing, .top], 4)
    }

    @ViewBuilder
    func image(for imgUrl: URL?, estimatedHeight: CGFloat? = nil) -> some View {
        if let imgUrl {
            AsyncImage(url: imgUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView() // TODO: update
                        .frame(height: estimatedHeight)
                case .success(let image):
                    image
                        .resizable()
                case .failure(let error):
                    Text("Bad: \(error.localizedDescription)") // TODO: use sf symbol
                        .frame(height: estimatedHeight)
                @unknown default:
                    fatalError()
                }
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func primaryImage(for imgUrl: URL?) -> some View {
        image(for: imgUrl, estimatedHeight: Self.estimatedPrimaryImageHeight)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    @ViewBuilder
    func productImage(for imgUrl: URL?) -> some View {
        image(for: imgUrl)
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
        SecondaryEditorialCard(editorial: .secondaryPreview)
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}

#Preview("3+ Products - Nike Air Force's Big Brother") {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        SecondaryEditorialCard(editorial: .secondaryPreview2)
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
