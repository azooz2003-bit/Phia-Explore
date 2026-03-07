//
//  PrimaryEditorialCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct PrimaryEditorialCard: View {
    static let estimatedHeight: CGFloat = 395
    static let estimatedPrimaryImageHeight: CGFloat = 178

    let editorial: FeedEditorial
    let imageService: ImageService
    let onEditorialSelection: (FeedEditorial) -> Void
    let onProductSelection: (FeedProduct) -> Void

    var body: some View {
        VStack(spacing: 4) {
            primaryImageSection

            if let products = editorial.products {
                productsList(products)
            }

            authorSection
        }
        .background(Color.Background.primary)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .onTapGesture {
            onEditorialSelection(editorial)
        }
    }

    @ViewBuilder
    var primaryImageSection: some View {
        primaryImage
            .overlay(alignment: .bottomLeading) {
                Text(editorial.title)
                    .customFont(.Label.medium)
                    .foregroundStyle(Color.Foreground.inverse)
                    .padding([.leading, .bottom, .trailing], 12)
            }
    }

    @ViewBuilder
    var primaryImage: some View {
        if let imgUrl = editorial.imgUrl {
            PhiaAsyncImage(url: imgUrl, estimatedHeight: Self.estimatedPrimaryImageHeight, imageService: imageService)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }

    @ViewBuilder
    func productsList(_ products: [FeedProduct]) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 4) {
                ForEach(products, id: \.id) {
                    productView($0)
                }
            }
            .padding(.horizontal, 4)
            .fixedSize(horizontal: false, vertical: true)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    func productView(_ product: FeedProduct) -> some View {
        if let imgUrl = product.imgUrl {
            PhiaAsyncImage(url: imgUrl, estimatedHeight: 175, imageService: imageService)
                .aspectRatio(contentMode: .fill)
                .frame(width: 123, height: 175)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .onTapGesture {
                    onProductSelection(product)
                }
        }
    }

    @ViewBuilder
    var authorSection: some View {
        if let author = editorial.author {
            HStack(spacing: 6) {
                authorImage

                HStack(spacing: 2) {
                    Text("By \(author.handle)")
                        .customFont(.ParagraphUi.xSmall)
                        .foregroundStyle(Color.Foreground.secondary)
                        .lineLimit(1)
                    Image(.Custom.verifiedCheckmark)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10.5, height: 10.5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom], 10)
            .padding(.top, 4)

        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var authorImage: some View {
        Group {
            if let authorImageURL = editorial.author?.imgUrl {
                PhiaAsyncImage(url: authorImageURL, imageService: imageService)
            } else {
                EmptyView()
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 18, height: 18)
        .clipShape(Circle())
    }
}

#Preview {
    @Previewable @State var feedRepository: FeedRepository = RemoteFeedRepository()
    @Previewable @Namespace var namespace
    let focusedEditorial: FeedEditorial = .primaryPreview

    FontManager.registerFonts()

    return VStack(alignment: .center) {
        Group {
            PrimaryEditorialCard(editorial: focusedEditorial, imageService: ImageService()) { _ in
                print("Editorial selected")
            } onProductSelection: {
                print("Product selected: \($0.itemName)")
            }
        }
        .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
