//
//  FeedRepository.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation
import PhiaAPI

protocol FeedRepository: Actor {
    func fetchPublicExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse
    func fetchAuthenticatedExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse
}

actor RemoteFeedRepository: FeedRepository {
    let api = PhiaAPI()

    /// - Throws: `PhiaAPIError` if the network request and decoding fails, ...
    func fetchPublicExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse {
        try await api.dispatchRequest(for: .publicExploreFeed(offset: offset, limit: limit)) as ExploreFeedResponse
    }

    /// - Throws: `PhiaAPIError` if the network request and decoding fails, ...
    func fetchAuthenticatedExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse {
        try await api.dispatchRequest(for: .authenticatedExploreFeed(offset: offset, limit: limit)) as ExploreFeedResponse
    }
}
