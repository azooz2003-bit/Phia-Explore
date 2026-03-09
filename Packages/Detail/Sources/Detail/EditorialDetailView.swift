//
//  EditorialDetailView.swift
//  Detail
//
//  Created by Abdulaziz Albahar on 3/8/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI
import ImageService

public struct EditorialDetailView: View {
    private let editorial: FeedEditorial
    private let imageService: ImageService

    public init(editorial: FeedEditorial, imageService: ImageService) {
        self.editorial = editorial
        self.imageService = imageService
    }

    private var imageUrls: [URL] {
        if let imgUrl = editorial.imgUrl {
            return [imgUrl]
        }
        return []
    }

    public var body: some View {
        GenericDetailView(title: editorial.title, imageUrls: imageUrls, brand: editorial.brand, products: editorial.products, imageService: imageService) {
            if let description = editorial.description {
                Text(description)
                    .customFont(.ParagraphEditorial.medium)
                    .foregroundStyle(Color.Foreground.secondary)
            }
        }
    }
}

#Preview("Detail") {
    FontManager.registerFonts()

    return NavigationStack {
        EditorialDetailView(editorial: .primaryPreview, imageService: ImageService())
    }
}

#Preview("Card to Detail") {
    FontManager.registerFonts()

    struct CardToDetail: View {
        let editorial: FeedEditorial = .primaryPreview
        @Namespace var namespace
        @State var selected: String?

        var body: some View {
            NavigationStack {
                Button { selected = editorial.id } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Background.secondary)
                        .frame(width: 180, height: 240)
                        .overlay { Text(editorial.title).customFont(.Label.small) }
                }
                .matchedTransitionSource(id: editorial.id, in: namespace)
                .navigationDestination(item: $selected) { _ in
                    EditorialDetailView(editorial: editorial, imageService: ImageService())
                        .navigationTransition(.zoom(sourceID: editorial.id, in: namespace))
                }
            }
        }
    }

    return CardToDetail()
}
