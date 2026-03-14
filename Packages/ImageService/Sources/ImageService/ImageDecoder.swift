//
//  ImageDecoder.swift
//  ImageService
//
//  Created by Abdulaziz Albahar on 3/9/26.
//

import UIKit

struct ImageDecoder {
    private static let screenScale: CGFloat = 3

    func decodeWithoutCaching(at path: URL, displayWidth: CGFloat) -> UIImage? {
        guard let source = CGImageSourceCreateWithURL(path as CFURL, nil) else { return nil }
        return downsampledImage(from: source, displayWidth: displayWidth)
    }

    func downsampledImage(from source: CGImageSource, displayWidth: CGFloat) -> UIImage? {
        let maxPixelSize = maxPixelSize(from: source, displayWidth: displayWidth)
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    private func maxPixelSize(from source: CGImageSource, displayWidth: CGFloat) -> Int {
        let widthInPx = displayWidth * Self.screenScale

        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as NSDictionary?,
              let originalWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let originalHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat,
              originalWidth > 0, originalHeight > 0 else {
            return Int(widthInPx)
        }

        let aspectRatio = max(originalWidth, originalHeight) / min(originalWidth, originalHeight)
        return Int(widthInPx * aspectRatio)
    }
}
