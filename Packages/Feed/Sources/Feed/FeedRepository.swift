//
//  FeedRepository.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation
import PhiaAPI

public protocol FeedRepository: Actor {
    func fetchPublicExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse
    func fetchAuthenticatedExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse
}

public actor RemoteFeedRepository: FeedRepository {
    let api = PhiaAPI()

    public init() {}

    /// - Throws: `PhiaAPIError` if the network request and decoding fails, ...
    public func fetchPublicExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse {
        try await api.dispatchRequest(for: .getPublicExploreFeed(offset: offset, limit: limit)) as ExploreFeedResponse
    }

    /// - Throws: `PhiaAPIError` if the network request and decoding fails, ...
    public func fetchAuthenticatedExploreFeed(offset: Int, limit: Int) async throws -> ExploreFeedResponse {
        try await api.dispatchRequest(for: .getAuthenticatedExploreFeed(offset: offset, limit: limit)) as ExploreFeedResponse
    }
}
