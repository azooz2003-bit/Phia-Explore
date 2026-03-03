import SwiftUI

struct FontWithLineHeightModifier: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}

public extension View {
    func customFont(_ customFont: CustomFont) -> some View {
        modifier(FontWithLineHeightModifier(font: customFont.font, lineHeight: customFont.lineHeight))
    }
}
