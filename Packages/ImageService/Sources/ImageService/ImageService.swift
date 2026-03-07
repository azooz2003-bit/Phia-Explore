//
//  ImageService.swift
//  ImageService
//
//  Created by Abdulaziz Albahar on 3/6/26.
//

import UIKit

/// Fetches the image at the URL by checking memory cache > disk cache > network call
public actor ImageService {
    enum ImageServiceError: Error {
        case decodingFailed
    }

    private let diskCache = DiskImageCache()
    /// an in memory cache for max 75 MB
    private let inMemoryCache = InMemoryImageCache(maxBytes: 75 * 1024 * 1024)
    private var inFlightRequests: [URL: Task<UIImage, Error>] = [:]

    public init() {}

    public func cachedAspectRatio(for url: URL) async -> CGFloat? {
        if let ratio = await inMemoryCache.getAspectRatio(for: url) {
            return ratio
        }
        return await diskCache.getAspectRatio(for: url)
    }

    public func fetchImage(at url: URL) async throws -> UIImage {
        if let cached = await inMemoryCache.get(at: url) {
            return cached
        }

        if let diskCached = await diskCache.get(at: url) {
            await inMemoryCache.set(diskCached, for: url)
            return diskCached
        }

        if let existing = inFlightRequests[url] {
            return try await existing.value
        }

        let task = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw ImageServiceError.decodingFailed
            }
            return image
        }

        inFlightRequests[url] = task

        do {
            let image = try await task.value
            inFlightRequests.removeValue(forKey: url)

            await inMemoryCache.set(image, for: url)
            await diskCache.set(image, for: url)

            return image
        } catch {
            inFlightRequests.removeValue(forKey: url)
            throw error
        }
    }
}
