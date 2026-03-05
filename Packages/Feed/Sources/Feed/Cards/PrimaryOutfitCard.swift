//
//  PrimaryOutfitCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI

struct PrimaryOutfitCard: View {
    let outfit: FeedOutfit

    @State var currentPage: Int? = nil

    var body: some View {
        VStack(spacing: 10) {
            outfitContent

            footer
        }
        .background(Color.Background.primary)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    @ViewBuilder
    var outfitContent: some View {
        if let products = outfit.products {
            catalogScrollView(for: products)
                .overlay(alignment: .topTrailing) {
                    // TODO: implement repository for bookmarked items
                    Button {

                    } label: {
                        BookmarkGlass(isBookmarked: false)
                    }
                    .padding([.trailing, .top], 12)
                }
                .overlay(alignment: .bottom) {
                    // TODO: ellipsis
                    // TODO: get rid of paging ellipsis if count == 1
                    if let products = outfit.products, products.count > 1 {
                        PageIndicators(totalPages: products.count + 1, currentPage: currentPage ?? 0)
                            .padding(.bottom, 12)
                    }
                }
  
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func catalogScrollView(for products: [FeedProduct]) -> some View {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    imageView(for: outfit.imgUrl)
                        .id(0)

                    ForEach(products.enumerated().map(\.self), id: \.1.id) { (i, product) in
                        imageView(for: product
                            .imgUrl)
                        .id(i + 1)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $currentPage)
    }

    @ViewBuilder
    func imageView(for imgUrl: URL?) -> some View {
        AsyncImage(url: imgUrl) { phase in
            switch phase {
            case .empty:
                ProgressView() // TODO: update
            case .success(let image):
                image
                    .resizable()
            case .failure(let error):
                Text("Bad: \(error.localizedDescription)") // TODO: use sf symbol
            @unknown default:
                fatalError()
            }
        }
        .aspectRatio(contentMode: .fill)
        .containerRelativeFrame(.horizontal)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    @ViewBuilder
    var footer: some View {
        HStack {
            Text(outfit.name)
                .customFont(.Label.medium)
                .foregroundStyle(Color.Content.primary)

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

#Preview {
    let focusedOutfit: FeedOutfit = .primaryPreview

    FontManager.registerFonts()

    return VStack(alignment: .center) {
        PrimaryOutfitCard(outfit: focusedOutfit)
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
