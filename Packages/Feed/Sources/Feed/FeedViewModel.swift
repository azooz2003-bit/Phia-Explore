//
//  FeedViewModel.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import SwiftUI
import PhiaAPI
import ImageService

@Observable
public class FeedViewModel {
    public struct MasonryChunk: Identifiable {
        public let id: String
        public let items: [MasonryItem]
        public let aspectRatios: [String: CGFloat]
    }

    public enum FeedType {
        case publicExplore
        case authenticated
    }

    private let feedRepository: FeedRepository
    private let imageService: ImageService
    private let feedType: FeedType
    private let pageLimit = 60
    private var nextOffset: Int = 0
    private var hasMore = true
    private var seenIDs = Set<String>()

    var gridChunks = [MasonryChunk]()
    var error: FeedError?

    var lastItemID: String? {
        gridChunks.last?.items.last?.id
    }

    public init(feedRepository: FeedRepository, imageService: ImageService, feedType: FeedType = .publicExplore) {
        self.feedRepository = feedRepository
        self.imageService = imageService
        self.feedType = feedType

        Task {
            await imageService.clearCache()
        }
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

            let newItems = response.sections
                .filter { $0.componentType == .masonry }
                .compactMap { $0.data.items }
                .flatMap { $0.compactMap { MasonryItem(fromResponse: $0) } }
                .filter { seenIDs.insert($0.id).inserted }

            guard !newItems.isEmpty else {
                self.hasMore = response.hasMore
                if let offset = response.offset {
                    self.nextOffset = offset
                }
                return
            }

            let aspectRatios = await prefetchAspectRatios(for: newItems)

            let multiplier = max(UserDefaults.standard.integer(forKey: "debugDataMultiplier"), 1)
            for copy in 0..<multiplier {
                let chunkId = "chunk-\(gridChunks.count)"
                gridChunks.append(MasonryChunk(id: chunkId, items: newItems, aspectRatios: aspectRatios))
                if copy == 0 {
                    print("[Debug] Page loaded: \(newItems.count) items × \(multiplier) copies")
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

    private func prefetchAspectRatios(for items: [MasonryItem]) async -> [String: CGFloat] {
        let prefetchItems = items.compactMap { item in
            guard let url = item.primaryImageURL else {
                print("\(item.cardName): primaryImageURL is nil")
                return nil as (String, URL)?
            }
            return (item.id, url) as (String, URL)?
        }

        return await withTaskGroup(of: (String, CGFloat?).self) { group in
            let maxConcurrent = 6
            var index = 0

            while index < min(maxConcurrent, prefetchItems.count) {
                let (id, url) = prefetchItems[index]
                group.addTask {
                    let ratio = await self.imageService.prefetchAspectRatio(for: url)
                    return (id, ratio)
                }
                index += 1
            }

            var result = [String: CGFloat]()
            for await (id, ratio) in group {
                if let ratio {
                    result[id] = ratio
                }

                if index < prefetchItems.count {
                    let (id, url) = prefetchItems[index]
                    group.addTask {
                        let ratio = await self.imageService.prefetchAspectRatio(for: url)
                        return (id, ratio)
                    }
                    index += 1
                }
            }
            return result
        }
    }
}
