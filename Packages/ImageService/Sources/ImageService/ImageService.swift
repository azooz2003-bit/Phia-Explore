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
    private let imageDecoder = ImageDecoder()
    private var inFlightRequests: [URL: Task<UIImage, Error>] = [:]
    private var inFlightPrefetches: [URL: Task<CGFloat?, Error>] = [:]

    public init() {}

    nonisolated public func cachedAspectRatio(for url: URL) -> CGFloat? {
        return diskCache?.getAspectRatio(for: url)
    }

    public func prefetchAspectRatio(for url: URL) async -> CGFloat? {
        if let cached = diskCache?.getAspectRatio(for: url) {
            return cached
        }

        if let existing = inFlightPrefetches[url] {
            return try? await existing.value
        }

        if let existing = inFlightRequests[url] {
            let image = try? await existing.value
            return image.map { $0.size.width / $0.size.height }
        }

        let task = Task<CGFloat?, Error> {
            let (data, _) = try await URLSession.shared.data(from: url)
            await diskCache?.set(data, for: url)
            return diskCache?.getAspectRatio(for: url)
        }

        inFlightPrefetches[url] = task

        let result = try? await task.value
        inFlightPrefetches.removeValue(forKey: url)
        return result
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

    public func clearCache() async {
        await diskCache?.clearCache()
    }
}
