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
    let focusedEditorial: FeedEditorial = .primaryPreview

    VStack(alignment: .center) {
        Group {
            PrimaryEditorialCard(editorial: focusedEditorial)
        }
    }
}
