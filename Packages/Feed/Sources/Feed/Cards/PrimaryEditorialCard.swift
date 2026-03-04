//
//  PrimaryEditorialCard.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import PhiaAPI

struct PrimaryEditorialCard: View {
    let editorial: FeedEditorial

    var body: some View {
        Text(editorial.title)
    }
}

#Preview {
    @Previewable @State var feedRepository: FeedRepository = RemoteFeedRepository()
    @Previewable @State var focusedEditorial: FeedEditorial? = nil

    VStack(alignment: .center) {
        Group {
            if let focusedEditorial {
                PrimaryEditorialCard(editorial: focusedEditorial)
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                focusedEditorial = try await feedRepository.fetchPublicExploreFeed(offset: 0, limit: 20).sections.first?.data.items.first(where: { $0.entityType == .editorial && $0.variant == .primary })?.editorial
            } catch {
                print(error)
            }
        }
    }
}
