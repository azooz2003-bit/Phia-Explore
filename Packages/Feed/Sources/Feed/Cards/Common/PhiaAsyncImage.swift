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
            ProgressView()
                .frame(height: estimatedHeight)
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
        state = .loading

        do {
            let image = try await imageService.fetchImage(at: url)
            state = .loaded(image)
        } catch {
            state = .failed(error)
        }
    }
}
