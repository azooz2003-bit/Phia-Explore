import SwiftUI
import DesignSystem

@main
struct PhiaOnsiteDemoApp: App {
    init() {
        FontManager.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
