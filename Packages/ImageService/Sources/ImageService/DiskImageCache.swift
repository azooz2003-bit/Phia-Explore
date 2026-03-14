//
//  DiskImageCache.swift
//  ImageService
//
//  Created by Abdulaziz Albahar on 3/6/26.
//

import UIKit
import CryptoKit

actor DiskImageCache {
    private let cacheDirectory: URL
    private let imageDecoder = ImageDecoder()

    init?() {
        guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        self.cacheDirectory = cachesDir.appendingPathComponent("PhiaImageCache", isDirectory: true)

        if !FileManager.default.fileExists(atPath: cacheDirectory.path()) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func set(_ data: Data, for url: URL) {
        let key = cacheKey(for: url)

        if let source = CGImageSourceCreateWithData(data as CFData, nil),
           let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as NSDictionary?,
           let width = properties[kCGImagePropertyPixelWidth] as? Double,
           let height = properties[kCGImagePropertyPixelHeight] as? Double, height > 0 {
            let aspectRatio = width / height
            try? String(describing: aspectRatio).write(to: cacheDirectory.appendingPathComponent(key + ".ratio"), atomically: true, encoding: .utf8)
        }

        try? data.write(to: cacheDirectory.appendingPathComponent(key + ".image"), options: .atomic)
    }

    func get(at url: URL, displayWidth: CGFloat) -> UIImage? {
        let key = cacheKey(for: url)
        let imagePath = cacheDirectory.appendingPathComponent(key + ".image")
        guard let image = imageDecoder.decodeWithoutCaching(at: imagePath, displayWidth: displayWidth) else { return nil }

        let ratioPath = cacheDirectory.appendingPathComponent(key + ".ratio")
        if !FileManager.default.fileExists(atPath: ratioPath.path()) {
            let aspectRatio = image.size.width / image.size.height
            try? String(describing: aspectRatio).write(to: ratioPath, atomically: true, encoding: .utf8)
        }

        return image
    }

    nonisolated func getAspectRatio(for url: URL) -> CGFloat? {
        let key = cacheKey(for: url)
        let ratioPath = cacheDirectory.appendingPathComponent(key + ".ratio")
        guard let string = try? String(contentsOf: ratioPath, encoding: .utf8),
              let value = Double(string) else { return nil }
        return CGFloat(value)
    }

    func clearCache() {
        guard let contents = try? FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) else { return }
        for file in contents {
            try? FileManager.default.removeItem(at: file)
        }
    }

    /// Hashing is necessary to avoid large filenames, get by filename errors occur otherwise making image fetching fail for long urls
    /// https://stackoverflow.com/a/59965839/17782408
    /// https://www.hackingwithswift.com/example-code/cryptokit/how-to-calculate-the-sha-hash-of-a-string-or-data-instance#:~:text=If%20you%20want%20to%20calculate,joined()
    nonisolated private func cacheKey(for url: URL) -> String {
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
