//
//  FeedGrid.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI

public struct FeedGrid: View {
    @State var feedVM: FeedViewModel
    @State var paginationTask: Task<Void, Never>?

    public init(feedVM: FeedViewModel) {
        self.feedVM = feedVM
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 6) {
                gridContent

                pageEnd
                // TODO: error message here if any
            }
            .padding(.horizontal, 8)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    var gridContent: some View {
        HStack(alignment: .top, spacing: 6) {
            LazyVStack(spacing: 6) {
                ForEach(feedVM.gridLeftItems, id: \.id) { item in
                    card(forItem: item)
                        .onAppear {
                            if item.id == feedVM.gridLeftItems.last?.id {
                                paginate()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)

            LazyVStack(spacing: 6) {
                ForEach(feedVM.gridRightItems, id: \.id) { item in
                    card(forItem: item)
                        .onAppear {
                            if item.id == feedVM.gridRightItems.last?.id {
                                paginate()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)
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
            print("Page end reached.")
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

    @ViewBuilder
    func card(forItem item: MasonryItem) -> some View {
        switch item {
        case .outfit(let variant):
            switch variant {
            case .primary(let outfit):
                PrimaryOutfitCard(outfit: outfit)
            case .secondary(let outfit):
                SecondaryOutfitCard(outfit: outfit)
            }
        case .editorial(let variant):
            switch variant {
            case .primary(let editorial):
                PrimaryEditorialCard(editorial: editorial) { _ in } onProductSelection: { _ in }
            case .secondary(let editorial):
                SecondaryEditorialCard(editorial: editorial)
            }
        case .product(let variant):
            switch variant {
            case .primary(let product):
                PrimaryProductCard(product: product)
            }
        }
    }
}

#Preview {
    FontManager.registerFonts()

    let vm = FeedViewModel(feedRepository: RemoteFeedRepository())
    vm.gridLeftItems = [
        .editorial(.primary(.primaryPreview)),
        .product(.primary(.primaryPreview)),
        .outfit(.secondary(.secondaryPreview)),
    ]
    vm.gridRightItems = [
        .outfit(.primary(.primaryPreview)),
        .editorial(.secondary(.secondaryPreview)),
        .outfit(.secondary(.secondaryPreview2)),
    ]

    return FeedGrid(feedVM: vm)
        .background(Color.Background.tertiary)
}
