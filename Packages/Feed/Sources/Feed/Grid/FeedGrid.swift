//
//  FeedGrid.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService
import Detail

public struct FeedGrid: View {
    @State var feedVM: FeedViewModel
    @State var paginationTask: Task<Void, Never>?
    @State var selectedItem: MasonryItem?
    @Namespace var namespace
    let imageService: ImageService

    public init(feedVM: FeedViewModel, imageService: ImageService) {
        self.feedVM = feedVM
        self.imageService = imageService
    }

    public var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 6) {
                    gridContent

                    pageEnd
                }
                .padding(.horizontal, 8)
                .padding(.top, 6)
            }
            .scrollIndicators(.hidden)
            .background(Color.Background.tertiary)
            .navigationDestination(item: $selectedItem) { item in
                destinationView(for: item)
            }
        }
    }

    @ViewBuilder
    func destinationView(for item: MasonryItem) -> some View {
        switch item {
        case .outfit(let variant):
            switch variant {
            case .primary(let outfit), .secondary(let outfit):
                OutfitDetailView(outfit: outfit, imageService: imageService)
                    .navigationTransition(.zoom(sourceID: item.id, in: namespace))
            }
        case .editorial(let variant):
            switch variant {
            case .primary(let editorial), .secondary(let editorial):
                EditorialDetailView(editorial: editorial, imageService: imageService)
                    .navigationTransition(.zoom(sourceID: item.id, in: namespace))
            }
        case .product(let variant):
            switch variant {
            case .primary(let product):
                ProductDetailView(product: product, imageService: imageService)
                    .navigationTransition(.zoom(sourceID: item.id, in: namespace))
            }
        }
    }

    @ViewBuilder
    var gridContent: some View {
        LazyVStack(spacing: 6) {
            ForEach(feedVM.gridChunks) { chunk in
                MasonryLayout(columns: 2, spacing: 6) {
                    ForEach(chunk.items, id: \.id) { item in
                        card(forItem: item, aspectRatio: chunk.aspectRatios[item.id], isLastItem: item.id == feedVM.lastItemID)
                    }
                }
            }
        }
    }

    @ViewBuilder
    var pageEnd: some View {
        Group {
            if let error = feedVM.error {
                VStack(spacing: 8) {
                    Text(error.title)
                        .customFont(.Label.large)
                        .foregroundStyle(Color.Content.primary)
                    Text(error.errorDescription)
                        .customFont(.Caption.small)
                        .foregroundStyle(Color.Foreground.disabled)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
            } else {
                Color.clear
            }
        }
        .onAppear {
            paginate()
        }
    }

    func paginate() {
        guard paginationTask == nil else { return }
        paginationTask = Task {
            await feedVM.didReachPageEnd()
            paginationTask = nil
        }
    }

    func calculateImageFrameHeight(for item: MasonryItem, aspectRatio: CGFloat?) -> CGFloat? {
        guard let aspectRatio, aspectRatio > 0 else { return nil }

        let totalWidth = UIScreen.main.bounds.width - 16
        let columnWidth = (totalWidth - 6) / 2

        switch item {
        case .editorial(.primary):
            return columnWidth / aspectRatio
        case .editorial(.secondary):
            let imageWidth = columnWidth - 40 - 4
            return imageWidth / aspectRatio
        case .outfit, .product:
            return columnWidth / aspectRatio
        }
    }

    @ViewBuilder
    func card(forItem item: MasonryItem, aspectRatio: CGFloat?, isLastItem: Bool) -> some View {
        let imageFrameHeight = calculateImageFrameHeight(for: item, aspectRatio: aspectRatio)
        Group {
            Button {
                selectedItem = item
            } label: {
                switch item {
                case .outfit(let variant):
                    switch variant {
                    case .primary(let outfit):
                        PrimaryOutfitCard(outfit: outfit, imageService: imageService)
                    case .secondary(let outfit):
                        SecondaryOutfitCard(outfit: outfit, imageService: imageService)
                    }
                case .editorial(let variant):
                    switch variant {
                    case .primary(let editorial):
                        PrimaryEditorialCard(editorial: editorial, imageService: imageService)
                    case .secondary(let editorial):
                        SecondaryEditorialCard(editorial: editorial, imageService: imageService)
                    }
                case .product(let variant):
                    switch variant {
                    case .primary(let product):
                        PrimaryProductCard(product: product, imageService: imageService)
                    }
                }
            }
            .buttonStyle(.plain)
            .onScrollVisibilityChange { isVisible in
                if isVisible, isLastItem {
                    paginate()
                }
            }
        }
        .canExpandVertically(item.hasExpandableImage)
        .primaryImageFrameHeight(imageFrameHeight)
        .cardName(item.cardName)
        .matchedTransitionSource(id: item.id, in: namespace)
    }

}

#Preview {
    FontManager.registerFonts()

    let imageService = ImageService()
    let vm = FeedViewModel(feedRepository: RemoteFeedRepository(), imageService: imageService)
    vm.gridChunks = [
        FeedViewModel.MasonryChunk(id: "preview", items: [
            .editorial(.primary(.primaryPreview)),
            .outfit(.primary(.primaryPreview)),
            .product(.primary(.primaryPreview)),
            .editorial(.secondary(.secondaryPreview)),
            .outfit(.secondary(.secondaryPreview)),
            .outfit(.secondary(.secondaryPreview2)),
        ], aspectRatios: [:])
    ]

    return FeedGrid(feedVM: vm, imageService: imageService)
        .background(Color.Background.tertiary)
}
