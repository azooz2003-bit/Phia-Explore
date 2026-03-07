import SwiftUI
import DesignSystem
import Feed
import ImageService

@main
struct PhiaOnsiteDemoApp: App {
    let feedVM = FeedViewModel(feedRepository: RemoteFeedRepository())
    let imageService = ImageService()

    init() {
        FontManager.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            FeedGrid(feedVM: feedVM, imageService: imageService)
                .background(Color.Background.tertiary)
                .background(ignoresSafeAreaEdges: .all)
        }
    }
}
