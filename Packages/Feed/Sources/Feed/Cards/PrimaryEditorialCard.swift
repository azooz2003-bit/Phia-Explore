//
//  PrimaryEditorialCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI

struct PrimaryEditorialCard: View {
    let editorial: FeedEditorial
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
        // TODO: add image caching fallback for `empty`
        AsyncImage(url: editorial.imgUrl) { phase in
            switch phase {
            case .empty:
                ProgressView() // TODO: update
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure(let error):
                Text("Bad: \(error.localizedDescription)") // TODO: use sf symbol
            @unknown default:
                fatalError()
            }
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 6))
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
        AsyncImage(url: product.imgUrl) { phase in
            switch phase {
            case .empty:
                ProgressView() // TODO: update
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure(let error):
                Text("Bad: \(error.localizedDescription)") // TODO: use sf symbol
            @unknown default:
                fatalError()
            }
        }
        .frame(width: 123, height: 175)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .onTapGesture {
            onProductSelection(product)
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
                AsyncImage(url: authorImageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // TODO: update
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(let error):
                        Text("Bad: \(error.localizedDescription)") // TODO: use sf symbol
                    @unknown default:
                        fatalError()
                    }
                }
            } else {
                EmptyView()
            }

        }
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
            PrimaryEditorialCard(editorial: focusedEditorial) { _ in
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
