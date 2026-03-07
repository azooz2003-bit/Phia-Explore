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
        let dir = entryDirectory(for: url)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        try? data.write(to: dir.appendingPathComponent("image"), options: .atomic)

        let aspectRatio = image.size.width / image.size.height
        try? String(describing: aspectRatio).write(to: dir.appendingPathComponent("ratio"), atomically: true, encoding: .utf8)
    }

    func get(at url: URL) -> UIImage? {
        let filePath = entryDirectory(for: url).appendingPathComponent("image")
        guard let data = try? Data(contentsOf: filePath) else { return nil }
        return UIImage(data: data)
    }

    func getAspectRatio(for url: URL) -> CGFloat? {
        let ratioPath = entryDirectory(for: url).appendingPathComponent("ratio")
        guard let string = try? String(contentsOf: ratioPath, encoding: .utf8),
              let value = Double(string) else { return nil }
        return CGFloat(value)
    }

    private func entryDirectory(for url: URL) -> URL {
        let encoded = Data(url.absoluteString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
        return cacheDirectory.appendingPathComponent(encoded, isDirectory: true)
    }
}
