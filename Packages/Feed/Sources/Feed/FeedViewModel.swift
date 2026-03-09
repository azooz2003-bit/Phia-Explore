//
//  FeedViewModel.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import SwiftUI
import PhiaAPI

@Observable
public class FeedViewModel {
    public enum FeedType {
        case publicExplore
        case authenticated
    }

    private let feedRepository: FeedRepository
    private let feedType: FeedType
    private let pageLimit = 60
    private var nextOffset: Int = 0
    private var hasMore = true

    var gridItems = [MasonryItem]()
    var error: FeedError?

    public init(feedRepository: FeedRepository, feedType: FeedType = .publicExplore) {
        self.feedRepository = feedRepository
        self.feedType = feedType
    }

    func didReachPageEnd() async {
        guard !Task.isCancelled else {
            return
        }

        guard hasMore else {
            return
        }

        do {
            let response: ExploreFeedResponse
            switch feedType {
            case .publicExplore:
                response = try await feedRepository.fetchPublicExploreFeed(offset: nextOffset, limit: pageLimit)
            case .authenticated:
                response = try await feedRepository.fetchAuthenticatedExploreFeed(offset: nextOffset, limit: pageLimit)
            }

            guard !Task.isCancelled else {
                return
            }

            var seenIDs = Set(gridItems.map(\.id))

            let newItems = response.sections
                .filter { $0.componentType == .masonry }
                .compactMap { $0.data.items }
                .flatMap { $0.compactMap { MasonryItem(fromResponse: $0) } }
                .filter { seenIDs.insert($0.id).inserted }

            gridItems.append(contentsOf: newItems)

            self.hasMore = response.hasMore
            if let offset = response.offset {
                self.nextOffset = offset
            }
            self.error = nil
        } catch let error as PhiaAPIError {
            self.error = .apiFailure(error)
        } catch {
            self.error = .unknown(error)
        }
    }
}
