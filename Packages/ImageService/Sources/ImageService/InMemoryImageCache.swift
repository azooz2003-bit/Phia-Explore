//
//  InMemoryImageCache.swift
//  ImageService
//
//  Created by Abdulaziz Albahar on 3/6/26.
//

import UIKit
import Foundation

actor InMemoryImageCache {
    struct CacheEntry {
        let image: UIImage
        let aspectRatio: CGFloat
        let byteSize: Int
        var lastTouched: Date = .now
    }

    let maxBytes: Int
    var currentBytes: Int = 0
    var cache: [URL : CacheEntry] = [:]

    init(maxBytes: Int) {
        self.maxBytes = maxBytes
    }

    func set(_ image: UIImage, for url: URL) {
        let byteSize = image.bytesInMemory

        if let existing = cache[url] {
            currentBytes -= existing.byteSize
        }

        // remove cache entries until we have enough space for the max limit
        while currentBytes + byteSize > maxBytes, !cache.isEmpty {
            let removeKey = cache.sorted {
                $0.value.lastTouched < $1.value.lastTouched
            }.first?.key

            if let removeKey, let removed = cache.removeValue(forKey: removeKey) {
                currentBytes -= removed.byteSize
            }
        }

        let aspectRatio = image.size.width / image.size.height
        cache[url] = CacheEntry(image: image, aspectRatio: aspectRatio, byteSize: byteSize)
        currentBytes += byteSize
    }

    func get(at url: URL) -> UIImage? {
        cache[url]?.lastTouched = .now
        return cache[url]?.image
    }

    func getAspectRatio(for url: URL) -> CGFloat? {
        return cache[url]?.aspectRatio
    }
}

private extension UIImage {
    var bytesInMemory: Int {
        guard let cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
