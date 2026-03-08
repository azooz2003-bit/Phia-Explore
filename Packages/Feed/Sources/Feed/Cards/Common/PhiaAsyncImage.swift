//
//  PhiaAsyncImage.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/6/26.
//

import SwiftUI
import DesignSystem
import ImageService

struct PhiaAsyncImage: View {
    let url: URL
    let estimatedHeight: CGFloat?
    let imageService: ImageService

    @State var state: ImageState = .idle
    @State var cachedAspectRatio: CGFloat?

    enum ImageState {
        case idle
        case loading
        case loaded(UIImage)
        case failed(Error)
    }

    init(url: URL, estimatedHeight: CGFloat? = nil, imageService: ImageService) {
        self.url = url
        self.estimatedHeight = estimatedHeight
        self.imageService = imageService
        self._cachedAspectRatio = State(initialValue: imageService.cachedAspectRatio(for: url))
    }

    var body: some View {
        content
            .onAppear {
                switch state {
                case .idle, .failed:
                    Task {
                        await loadImage()
                    }
                default:
                    break
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
                ProgressView()
                    .frame(height: estimatedHeight)
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
            let image = try await imageService.fetchImage(at: url)
            state = .loaded(image)
        } catch {
            state = .failed(error)
        }
    }
}
