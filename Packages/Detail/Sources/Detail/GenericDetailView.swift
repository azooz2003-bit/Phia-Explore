//
//  GenericDetailView.swift
//  Detail
//
//  Created by Abdulaziz Albahar on 3/8/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct GenericDetailView<Subtitle: View>: View {
    let title: String
    let imageUrls: [URL]
    let subtitle: Subtitle
    let author: FeedAuthor?
    let brand: FeedBrand?
    let products: [FeedProduct]?
    let imageService: ImageService

    private var hasMainImage: Bool { !imageUrls.isEmpty }

    @Environment(\.dismiss) private var dismiss

    init(title: String, imageUrls: [URL], author: FeedAuthor? = nil, brand: FeedBrand? = nil, products: [FeedProduct]? = nil, imageService: ImageService, @ViewBuilder subtitle: () -> Subtitle) {
        self.title = title
        self.imageUrls = imageUrls
        self.author = author
        self.brand = brand
        self.products = products
        self.imageService = imageService
        self.subtitle = subtitle()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                heroImages

                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .customFont(.HeadingSans.small)
                        .foregroundStyle(Color.Content.primary)

                    subtitle

                    if let author {
                        authorSection(author)
                    } else if let brand {
                        brandSection(brand)
                    }

                    if let products, !products.isEmpty {
                        ProductsRow(products: products, imageService: imageService)
                    }

                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .ignoresSafeArea(edges: hasMainImage ? .top : [])
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Content.primary)
                        .frame(width: 44, height: 44)
                        .phiaGlassPre26()
                }
                Spacer()
            }
        }
        .toolbarBackground(.hidden, for: .bottomBar)
    }

    @ViewBuilder
    private var heroImages: some View {
        if !imageUrls.isEmpty {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(imageUrls.indices, id: \.self) { index in
                        PhiaAsyncImage(url: imageUrls[index], displayWidth: UIScreen.main.bounds.width, imageService: imageService)
                            .aspectRatio(contentMode: .fill)
                            .containerRelativeFrame(.horizontal)
                            .clipped()
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .frame(minHeight: 400)
        }
    }

    @ViewBuilder
    private func authorSection(_ author: FeedAuthor) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()

            HStack(spacing: 10) {
                if let imgUrl = author.imgUrl {
                    PhiaAsyncImage(url: imgUrl, displayWidth: 48, imageService: imageService)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(author.name)
                            .customFont(.Label.small)
                            .foregroundStyle(Color.Content.primary)

                        Image(.Custom.verifiedCheckmark)
                            .resizable()
                            .frame(width: 14, height: 14)
                    }

                    Text("\(author.handle)")
                        .customFont(.Caption.xSmall)
                        .foregroundStyle(Color.Foreground.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private func brandSection(_ brand: FeedBrand) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()

            HStack(spacing: 10) {
                if let logoUrl = brand.logoUrl {
                    PhiaAsyncImage(url: logoUrl, displayWidth: 48, imageService: imageService)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .background(Color.Content.primary)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(brand.displayName)
                        .customFont(.Label.small)
                        .foregroundStyle(Color.Content.primary)

                    if let description = brand.description {
                        Text(description)
                            .customFont(.Caption.xSmall)
                            .foregroundStyle(Color.Foreground.secondary)
                            .lineLimit(2)
                    }
                }
            }

            if let websiteUrl = brand.websiteUrl {
                Link(destination: websiteUrl) {
                    Text(websiteUrl.host ?? websiteUrl.absoluteString)
                        .customFont(.Caption.xSmall)
                        .foregroundStyle(Color.Foreground.tertiary)
                }
            }
        }
    }
}

#Preview {
    FontManager.registerFonts()
    let editorial: FeedEditorial = .primaryPreview

    return NavigationStack {
        GenericDetailView(title: editorial.title, imageUrls: [editorial.imgUrl!], author: editorial.author, brand: editorial.brand, products: editorial.products, imageService: ImageService()) {
            Text(editorial.description!)
                .customFont(.ParagraphEditorial.medium)
                .foregroundStyle(Color.Foreground.secondary)
        }
    }
}
