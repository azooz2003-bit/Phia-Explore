//
//  DiskImageCache.swift
//  ImageService
//
//  Created by Abdulaziz Albahar on 3/6/26.
//

import UIKit

actor DiskImageCache {
    private let cacheDirectory: URL

    init?() {
        guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        self.cacheDirectory = cachesDir.appendingPathComponent("PhiaImageCache", isDirectory: true)

        if !FileManager.default.fileExists(atPath: cacheDirectory.path()) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func set(_ image: UIImage, for url: URL) {
        let key = cacheKey(for: url)

        let aspectRatio = image.size.width / image.size.height
        try? String(describing: aspectRatio).write(
            to: cacheDirectory.appendingPathComponent(key + ".ratio"),
            atomically: true,
            encoding: .utf8
        )

        guard let data = image.pngData() else { return }
        try? data.write(
            to: cacheDirectory.appendingPathComponent(key + ".image"),
            options: .atomic
        )
    }

    func get(at url: URL) -> UIImage? {
        let key = cacheKey(for: url)
        let imagePath = cacheDirectory.appendingPathComponent(key + ".image")
        guard let data = try? Data(contentsOf: imagePath) else { return nil }
        guard let image = UIImage(data: data) else { return nil }

        let ratioPath = cacheDirectory.appendingPathComponent(key + ".ratio")
        if !FileManager.default.fileExists(atPath: ratioPath.path()) {
            let aspectRatio = image.size.width / image.size.height
            try? String(describing: aspectRatio).write(to: ratioPath, atomically: true, encoding: .utf8)
        }

        return image
    }

    nonisolated func getCachedImage(for url: URL) -> UIImage? {
        let key = cacheKey(for: url)
        let imagePath = cacheDirectory.appendingPathComponent(key + ".image")
        guard let data = try? Data(contentsOf: imagePath) else { return nil }
        return UIImage(data: data)
    }

    nonisolated func getAspectRatio(for url: URL) -> CGFloat? {
        let key = cacheKey(for: url)
        let ratioPath = cacheDirectory.appendingPathComponent(key + ".ratio")
        guard let string = try? String(contentsOf: ratioPath, encoding: .utf8),
              let value = Double(string) else { return nil }
        return CGFloat(value)
    }

    nonisolated private func cacheKey(for url: URL) -> String {
        Data(url.absoluteString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
    }
}
