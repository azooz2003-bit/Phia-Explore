//
//  RootView.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/7/26.
//

import SwiftUI
import ImageService
import Feed

public struct RootView: View {
    @State var selectedTab: FeedTab = .explore
    @State var exploreVM: FeedViewModel
    @State var forYouVM: FeedViewModel
    let imageService: ImageService

    public init(feedRepository: FeedRepository, imageService: ImageService) {
        self._exploreVM = State(initialValue: FeedViewModel(feedRepository: feedRepository, feedType: .publicExplore))
        self._forYouVM = State(initialValue: FeedViewModel(feedRepository: feedRepository, feedType: .authenticated))
        self.imageService = imageService
    }

    public var body: some View {
        VStack(spacing: 0) {
            FeedHeader(selectedTab: $selectedTab)
                .padding(.top, 12)

            Group {
                switch selectedTab {
                case .explore:
                    FeedGrid(feedVM: exploreVM, imageService: imageService)
                case .forYou:
                    FeedGrid(feedVM: forYouVM, imageService: imageService)
                case .trendReport:
                    Text(selectedTab.rawValue)
                        .customFont(.Caption.medium)
                        .foregroundStyle(Color.Foreground.secondary)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}
