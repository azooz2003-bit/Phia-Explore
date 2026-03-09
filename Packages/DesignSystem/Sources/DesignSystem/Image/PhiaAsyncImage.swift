//
//  PhiaAsyncImage.swift
//  DesignSystem
//
//  Created by Abdulaziz Albahar on 3/6/26.
//

import SwiftUI
import ImageService

public struct PhiaAsyncImage: View {
    let url: URL
    let estimatedHeight: CGFloat?
    let displayWidth: CGFloat
    let imageService: ImageService

    @State var state: ImageState = .idle
    @State var cachedAspectRatio: CGFloat?

    public enum ImageState {
        case idle
        case loading
        case loaded(UIImage)
        case failed(Error)
    }

    public init(url: URL, estimatedHeight: CGFloat? = nil, displayWidth: CGFloat = 200, imageService: ImageService) {
        self.url = url
        self.estimatedHeight = estimatedHeight
        self.displayWidth = displayWidth
        self.imageService = imageService

        self._cachedAspectRatio = State(initialValue: imageService.cachedAspectRatio(for: url))
    }

    public var body: some View {
        content
            .onScrollVisibilityChange(threshold: 0.05) { isVisible in
                if isVisible {
                    switch state {
                    case .idle, .failed:
                        Task {
                            await loadImage()
                        }
                    default:
                        break
                    }
                } else {
                    state = .idle
                }
            }
    }

    @ViewBuilder
    var content: some View {
        switch state {
        case .idle, .loading:
            if let cachedAspectRatio {
                Color.clear
                    .aspectRatio(cachedAspectRatio, contentMode: .fill)
                    .overlay { ProgressView() }
            } else {
                Color.clear
                    .frame(height: estimatedHeight)
                    .overlay { ProgressView() }
            }
        case .loaded(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
        case .failed:
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(Color.Content.negative)
                .frame(height: estimatedHeight)
        }
    }

    private func loadImage() async {
        if case .loaded = state { return }

        state = .loading

        do {
            let image = try await imageService.fetchImage(at: url, displayWidth: displayWidth)
            self.cachedAspectRatio = imageService.cachedAspectRatio(for: url)
            state = .loaded(image)
        } catch {
            state = .failed(error)
        }
    }
}
