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

    private let diskCache: DiskImageCache?  = DiskImageCache()
    /// an in memory cache for max 75 MB
    private let inMemoryCache = InMemoryImageCache(maxBytes: 75 * 1024 * 1024)
    private let imageDecoder = ImageDecoder()
    private var inFlightRequests: [URL: Task<UIImage, Error>] = [:]

    public init() {}

    nonisolated public func cachedAspectRatio(for url: URL) -> CGFloat? {
        return diskCache?.getAspectRatio(for: url)
    }

    public func fetchImage(at url: URL, displayWidth: CGFloat = 200) async throws -> UIImage {
        if let diskCached = await diskCache?.get(at: url, displayWidth: displayWidth) {
            return diskCached
        }

        if let existing = inFlightRequests[url] {
            return try await existing.value
        }

        let task = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let source = CGImageSourceCreateWithData(data as CFData, nil),
                  let image = imageDecoder.downsampledImage(from: source, displayWidth: displayWidth)
            else {
                throw ImageServiceError.decodingFailed
            }
            await diskCache?.set(data, for: url)
            return image
        }

        inFlightRequests[url] = task

        do {
            let image = try await task.value
            inFlightRequests.removeValue(forKey: url)

            return image
        } catch {
            inFlightRequests.removeValue(forKey: url)
            throw error
        }
    }
}
