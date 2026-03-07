//
//  DiskImageCache.swift
//  ImageService
//
//  Created by Abdulaziz Albahar on 3/6/26.
//

import UIKit

actor DiskImageCache {
    private let cacheDirectory: URL

    init() {
        let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = cachesDir.appendingPathComponent("ImageCache", isDirectory: true)

        if !FileManager.default.fileExists(atPath: cacheDirectory.path()) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func set(_ image: UIImage, for url: URL) {
        guard let data = image.pngData() else { return }
        let filePath = filePath(for: url)
        try? data.write(to: filePath, options: .atomic)
    }

    func get(at url: URL) -> UIImage? {
        let filePath = filePath(for: url)
        guard let data = try? Data(contentsOf: filePath) else { return nil }
        return UIImage(data: data)
    }

    private func filePath(for url: URL) -> URL {
        let encoded = Data(url.absoluteString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
        return cacheDirectory.appendingPathComponent(encoded)
    }
}
