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
        var lastTouched: Date = .now
    }

    let maxImages: Int
    var cache: [URL : CacheEntry] = [:]

    init(maxImages: Int) {
        self.maxImages = maxImages
    }

    func set(_ image: UIImage, for url: URL) {
        if cache.keys.contains(url) {
            cache[url] = CacheEntry(image: image)
            return
        }

        if cache.count >= maxImages {
            let removeKey = cache.sorted {
                $0.value.lastTouched < $1.value.lastTouched
            }.first?.key

            // will always succeed since cache.count >= 100
            if let removeKey {
                cache.removeValue(forKey: removeKey)
            }
        }

        cache[url] = CacheEntry(image: image)
    }

    func get(at url: URL) -> UIImage? {
        cache[url]?.lastTouched = .now
        return cache[url]?.image
    }
}
