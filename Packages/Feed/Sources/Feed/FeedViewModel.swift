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
    let feedRepository: FeedRepository
    let pageLimit = 60
    var nextOffset: Int = 0
    var hasMore = true

    var gridLeftItems = [MasonryItem]()
    var gridRightItems = [MasonryItem]()
    var error: FeedError?

    var leftColumnEstHeight: CGFloat {
        gridLeftItems.reduce(0) { res, item in
            res + item.estimatedHeight
        }
    }
    var rightColumnEstHeight: CGFloat {
        gridRightItems.reduce(0) { res, item in
            res + item.estimatedHeight
        }
    }

    public init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }

    func didReachPageEnd() async {
        guard !Task.isCancelled else {
            return
        }

        guard hasMore else {
            return
        }

        do {
            let response = try await feedRepository.fetchAuthenticatedExploreFeed(offset: nextOffset, limit: pageLimit)

            guard !Task.isCancelled else {
                return
            }

            let existing = gridLeftItems + gridRightItems

            let allMasonryItems = response.sections
                .filter { $0.componentType == .masonry }
                .compactMap { $0.data.items }
                .flatMap { $0.compactMap { MasonryItem(fromResponse: $0) } }
                .filter { newItem in
                    !existing.contains { $0.id == newItem.id }
                }

            for masonryItem in allMasonryItems {
                if leftColumnEstHeight <= rightColumnEstHeight {
                    gridLeftItems.append(masonryItem)
                } else {
                    gridRightItems.append(masonryItem)
                }
            }

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
