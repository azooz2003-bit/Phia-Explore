import SwiftUI
import DesignSystem
import Feed

@main
struct PhiaOnsiteDemoApp: App {
    let feedVM = FeedViewModel(feedRepository: RemoteFeedRepository())
    
    init() {
        FontManager.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            FeedGrid(feedVM: feedVM)
                .background(Color.Background.tertiary)
                .background(ignoresSafeAreaEdges: .all)
        }
    }
}
