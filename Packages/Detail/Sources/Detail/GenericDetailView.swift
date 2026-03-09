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
    let brand: FeedBrand?
    let products: [FeedProduct]?
    let imageService: ImageService

    @Environment(\.dismiss) private var dismiss

    init(title: String, imageUrls: [URL], brand: FeedBrand? = nil, products: [FeedProduct]? = nil, imageService: ImageService, @ViewBuilder subtitle: () -> Subtitle) {
        self.title = title
        self.imageUrls = imageUrls
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

                    if let brand {
                        brandSection(brand)
                    }

                    if let products, !products.isEmpty {
                        ProductsRow(products: products, imageService: imageService)
                    }

                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea()
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
                        PhiaAsyncImage(url: imageUrls[index], imageService: imageService)
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
    private func brandSection(_ brand: FeedBrand) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()

            HStack(spacing: 10) {
                if let logoUrl = brand.logoUrl {
                    PhiaAsyncImage(url: logoUrl, imageService: imageService)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.Background.secondary)
                        .frame(width: 36, height: 36)
                        .overlay {
                            Text(String(brand.displayName.prefix(1)))
                                .customFont(.Label.small)
                                .foregroundStyle(Color.Foreground.secondary)
                        }
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
        GenericDetailView(title: editorial.title, imageUrls: [editorial.imgUrl!], brand: editorial.brand, products: editorial.products, imageService: ImageService()) {
            Text(editorial.description!)
                .customFont(.ParagraphEditorial.medium)
                .foregroundStyle(Color.Foreground.secondary)
        }
    }
}
