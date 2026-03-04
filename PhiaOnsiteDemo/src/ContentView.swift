import SwiftUI
import DesignSystem

struct ContentView: View {
    var body: some View {
        VStack {
          Text("Test")
                .customFont(.Display.large)
        }
        .padding()
    }
}

#Preview {
    // Register fonts for the preview
    FontManager.setupForPreview()
    return ContentView()
}
