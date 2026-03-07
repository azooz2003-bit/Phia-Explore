import SwiftUI
import DesignSystem
import Feed
import ImageService

@main
struct PhiaOnsiteDemoApp: App {
    let imageService = ImageService()

    init() {
        FontManager.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            RootView(feedRepository: RemoteFeedRepository(), imageService: imageService)
        }
    }
}
