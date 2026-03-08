//
//  PagedItemCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

struct GenericItemCard<Subtitle: View>: View {
    let title: String
    let titleLineLimit: Int
    let subtitle: Subtitle
    let imageUrls: [URL]?
    let estimatedPrimaryImageHeight: CGFloat
    let imageService: ImageService
    let isBookmarked: Bool
    let onBookmarkToggle: () -> Void

    @State var currentPage: Int? = nil

    init(title: String, titleLineLimit: Int, imageUrls: [URL]?, estimatedPrimaryImageHeight: CGFloat, imageService: ImageService, isBookmarked: Bool, onBookmarkToggle: @escaping () -> Void, @ViewBuilder subtitle: () -> Subtitle) {
        self.title = title
        self.titleLineLimit = titleLineLimit
        self.imageUrls = imageUrls
        self.estimatedPrimaryImageHeight = estimatedPrimaryImageHeight
        self.imageService = imageService
        self.isBookmarked = isBookmarked
        self.onBookmarkToggle = onBookmarkToggle
        self.subtitle = subtitle()
    }

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
        if let imageUrls, !imageUrls.isEmpty {
            catalogScrollView(for: imageUrls)
                .overlay(alignment: .topTrailing) {
                    BookmarkGlassButton(isBookmarked: isBookmarked) {
                        onBookmarkToggle()
                    }
                    .padding([.trailing, .top], 12)
                }
                .overlay(alignment: .bottom) {
                    if imageUrls.count > 1 {
                        PageIndicators(totalPages: imageUrls.count, currentPage: currentPage ?? 0)
                            .padding(.bottom, 12)
                    }
                }
  
        } else {
            Color.clear
                .frame(height: 0)
        }
    }

    @ViewBuilder
    func catalogScrollView(for imageUrls: [URL]) -> some View {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(imageUrls.enumerated().map(\.self), id: \.0) { (i, imgUrl) in
                        imageView(for: imgUrl)
                        .id(i)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $currentPage)
            .scrollDisabled(imageUrls.count == 1)
    }

    @ViewBuilder
    func imageView(for imgUrl: URL) -> some View {
        PhiaAsyncImage(url: imgUrl, estimatedHeight: estimatedPrimaryImageHeight, imageService: imageService)
            .aspectRatio(contentMode: .fill)
            .containerRelativeFrame(.horizontal)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    @ViewBuilder
    var footer: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                subtitle

                Text(title)
                    .customFont(.Label.medium)
                    .foregroundStyle(Color.Content.primary)
                    .lineLimit(titleLineLimit)
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

extension GenericItemCard where Subtitle == AnyView {
    init(title: String, titleLineLimit: Int, subtitle: String?, imageUrls: [URL]?, estimatedPrimaryImageHeight: CGFloat, imageService: ImageService, isBookmarked: Bool, onBookmarkToggle: @escaping () -> Void) {
        self.init(title: title, titleLineLimit: titleLineLimit, imageUrls: imageUrls, estimatedPrimaryImageHeight: estimatedPrimaryImageHeight, imageService: imageService, isBookmarked: isBookmarked, onBookmarkToggle: onBookmarkToggle) {
            AnyView(
                Group {
                    if let subtitle {
                        Text(subtitle)
                            .customFont(.CaptionMono.xSmall)
                            .foregroundStyle(Color.Foreground.disabled)
                            .lineLimit(1)
                    } else {
                        EmptyView()
                    }
                }
            )
        }
    }
}

#Preview("Outfit") {
    let focusedOutfit: FeedOutfit = .primaryPreview

    var urls: [URL] {
        [focusedOutfit.imgUrl].compactMap(\.self) + (focusedOutfit.products?.compactMap(\.imgUrl) ?? [])
    }

    FontManager.registerFonts()

    return VStack(alignment: .center) {
        GenericItemCard(title: "focusedOutfit.name q wrqfegeqge", titleLineLimit: 1, subtitle: nil, imageUrls: urls, estimatedPrimaryImageHeight: PrimaryOutfitCard.estimatedHeight, imageService: ImageService(), isBookmarked: false, onBookmarkToggle: {})
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}

#Preview("Product") {
    let focusedOutfit: FeedOutfit = .primaryPreview

    var urls: [URL] {
        [focusedOutfit.imgUrl].compactMap(\.self) + (focusedOutfit.products?.compactMap(\.imgUrl) ?? [])
    }

    FontManager.registerFonts()

    return VStack(alignment: .center) {
        GenericItemCard(title: "focusedOutfit.name q wrqfegeqge", titleLineLimit: 2, subtitle: "RHODE • $30", imageUrls: [urls[0]], estimatedPrimaryImageHeight: PrimaryOutfitCard.estimatedHeight, imageService: ImageService(), isBookmarked: false, onBookmarkToggle: {})
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
