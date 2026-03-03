import UIKit
import SwiftUI

public enum FontManager {
    private static var fontsRegistered = false

    public static func registerFonts() {
        guard !fontsRegistered else { return }
        fontsRegistered = true

        let fonts: [(fontName: String, fontExtension: String)] = [
            ("GTSuperDisplay-Light", "otf"),
            ("GTSuperDisplay-LightItalic", "otf"),
            ("GTSuperDisplay-Regular", "otf"),
            ("PPNeueMontreal-Regular", "otf"),
            ("PPNeueMontreal-Medium", "otf"),
            ("RobotoMono-Regular", "ttf"),
            ("RobotoMono-Light", "ttf"),
            ("Mayonice", "ttf"),
        ]

        for font in fonts {
            registerFont(bundle: .main, fontName: font.fontName, fontExtension: font.fontExtension)
        }
    }

    // Convenience method for SwiftUI previews
    public static func setupForPreview() {
        registerFonts()
    }

    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider)
        else {
            print("Couldn't create font from data: \(fontName)")
            return
        }

        var error: Unmanaged<CFError>?

        if CTFontManagerRegisterGraphicsFont(font, &error) {
            print("✅ Successfully registered font: \(fontName)")
        } else if let error {
            print("⚠️ Error registering font \(fontName): \(error.takeRetainedValue())")
        } else {
            print("⚠️ Unknown error registering font: \(fontName)")
        }
    }
}

public struct CustomFont {
    public let font: UIFont
    public let lineHeight: CGFloat
    public let tracking: CGFloat?

    public init(font: UIFont, lineHeight: CGFloat, tracking: CGFloat? = nil) {
        self.font = font
        self.lineHeight = lineHeight
        self.tracking = tracking
    }
}

public extension CustomFont {
    static let initials = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 59), lineHeight: 110, tracking: -0.39)

    enum Display {
        public static let large = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 96), lineHeight: 112, tracking: -0.04)
        public static let medium = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 56), lineHeight: 64, tracking: -0.04)
        public static let small = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 44), lineHeight: 52, tracking: -0.04)
        public static let xSmall = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 36), lineHeight: 44, tracking: -0.04)
        public static let xxSmall = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 28), lineHeight: 36, tracking: -0.04)
        public static let xxxSmall = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 24), lineHeight: 32, tracking: -0.04)
        public static let xxxxSmall = CustomFont(font: .gtSuperDisplayFont(weight: .light, size: 20), lineHeight: 24, tracking: -0.04)
    }

    enum DisplayItalic {
        public static let large = CustomFont(font: .gtSuperDisplayLightItalicFont(size: 96), lineHeight: 112)
        public static let medium = CustomFont(font: .gtSuperDisplayLightItalicFont(size: 56), lineHeight: 64)
        public static let small = CustomFont(font: .gtSuperDisplayLightItalicFont(size: 44), lineHeight: 52)
        public static let xSmall = CustomFont(font: .gtSuperDisplayLightItalicFont(size: 36), lineHeight: 44)
        public static let xxSmall = CustomFont(font: .gtSuperDisplayLightItalicFont(size: 28), lineHeight: 36)
        public static let xxxSmall = CustomFont(font: .gtSuperDisplayLightItalicFont(size: 24), lineHeight: 32)
        public static let xxxxSmall = CustomFont(font: .gtSuperDisplayLightItalicFont(size: 20), lineHeight: 24)
    }

    enum HeadingSans {
        public static let xxLarge = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 40), lineHeight: 52)
        public static let xLarge = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 36), lineHeight: 44)
        public static let large = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 32), lineHeight: 40)
        public static let medium = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 28), lineHeight: 36)
        public static let small = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 24), lineHeight: 32)
        public static let xSmall = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 20), lineHeight: 28)
    }

    enum HeadingSerif {
        public static let xxLarge = CustomFont(font: .gtSuperDisplayFont(weight: .regular, size: 40), lineHeight: 52)
        public static let xLarge = CustomFont(font: .gtSuperDisplayFont(weight: .regular, size: 36), lineHeight: 44)
        public static let large = CustomFont(font: .gtSuperDisplayFont(weight: .regular, size: 32), lineHeight: 40)
        public static let medium = CustomFont(font: .gtSuperDisplayFont(weight: .regular, size: 28), lineHeight: 36)
        public static let small = CustomFont(font: .gtSuperDisplayFont(weight: .regular, size: 24), lineHeight: 32)
        public static let xSmall = CustomFont(font: .gtSuperDisplayFont(weight: .regular, size: 20), lineHeight: 28)
        public static let xxSmall = CustomFont(font: .gtSuperDisplayFont(weight: .regular, size: 14), lineHeight: 18)
    }

    enum Label {
        public static let xLarge = CustomFont(font: .ppNeueMontrealFont(weight: .medium, size: 20), lineHeight: 28)
        public static let large = CustomFont(font: .ppNeueMontrealFont(weight: .medium, size: 18), lineHeight: 24)
        public static let medium = CustomFont(font: .ppNeueMontrealFont(weight: .medium, size: 16), lineHeight: 20)
        public static let small = CustomFont(font: .ppNeueMontrealFont(weight: .medium, size: 14), lineHeight: 16)
        public static let xSmall = CustomFont(font: .ppNeueMontrealFont(weight: .medium, size: 12), lineHeight: 16)
    }

    enum ParagraphUi {
        public static let xLarge = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 20), lineHeight: 28)
        public static let large = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 18), lineHeight: 24)
        public static let medium = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 16), lineHeight: 20)
        public static let small = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 14), lineHeight: 16)
        public static let xSmall = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 12), lineHeight: 16)
    }

    enum ParagraphEditorial {
        public static let xLarge = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 20), lineHeight: 36)
        public static let large = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 18), lineHeight: 28)
        public static let medium = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 16), lineHeight: 24)
        public static let small = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 14), lineHeight: 20)
        public static let xSmall = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 12), lineHeight: 18)
    }

    enum Caption {
        public static let medium = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 16), lineHeight: 20)
        public static let small = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 14), lineHeight: 16)
        public static let xSmall = CustomFont(font: .ppNeueMontrealFont(weight: .regular, size: 12), lineHeight: 14)
        public static let xxSmall = CustomFont(font: .ppNeueMontrealFont(weight: .light, size: 11), lineHeight: 14)
    }

    enum CaptionMono {
        public static let xLarge = CustomFont(font: .robotoMonoFont(weight: .regular, size: 20), lineHeight: 28)
        public static let large = CustomFont(font: .robotoMonoFont(weight: .regular, size: 18), lineHeight: 28)
        public static let medium = CustomFont(font: .robotoMonoFont(weight: .regular, size: 16), lineHeight: 20)
        public static let small = CustomFont(font: .robotoMonoFont(weight: .regular, size: 14), lineHeight: 16)
        public static let xSmall = CustomFont(font: .robotoMonoFont(weight: .regular, size: 12), lineHeight: 14)
    }

    enum Mayonice {
        public static let xxLarge = CustomFont(font: .mayoniceFont(size: 40), lineHeight: 52)
        public static let xLarge = CustomFont(font: .mayoniceFont(size: 36), lineHeight: 44)
        public static let large = CustomFont(font: .mayoniceFont(size: 32), lineHeight: 40)
        public static let medium = CustomFont(font: .mayoniceFont(size: 28), lineHeight: 36)
        public static let small = CustomFont(font: .mayoniceFont(size: 24), lineHeight: 32)
        public static let xSmall = CustomFont(font: .mayoniceFont(size: 20), lineHeight: 28)
        public static let xxSmall = CustomFont(font: .mayoniceFont(size: 16), lineHeight: 24)
    }
}

public extension UIFont {
    static func gtSuperDisplayFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        if let font = UIFont(name: "GTSuperDisplay-\(weight.weightString)", size: size) {
            return font
        } else {
            debugPrint("Font not found: GTSuperDisplay-\(weight.weightString)")
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    static func gtSuperDisplayLightItalicFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "GTSuperDisplay-LightItalic", size: size) {
            return font
        } else {
            debugPrint("Font not found: GTSuperDisplay-LightItalic")
            return UIFont.systemFont(ofSize: size, weight: .light)
        }
    }

    static func ppNeueMontrealFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        if let font = UIFont(name: "PPNeueMontreal-\(weight.weightString)", size: size) {
            return font
        } else {
            debugPrint("Font not found: PPNeueMontreal-\(weight.weightString)")
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    static func robotoMonoFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        if let font = UIFont(name: "RobotoMono-\(weight.weightString)", size: size) {
            return font
        } else {
            debugPrint("Font not found: RobotoMono-\(weight.weightString)")
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    static func mayoniceFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Mayonice", size: size) {
            return font
        } else {
            debugPrint("Font not found: Mayonice")
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
}

extension UIFont.Weight {
    var weightString: String {
        switch self {
        case .regular:
            return "Regular"
        case .bold:
            return "Bold"
        case .thin:
            return "Thin"
        case .light:
            return "Light"
        case .medium:
            return "Medium"
        case .heavy:
            return "Heavy"
        case .semibold:
            return "SemiBold"
        case .black:
            return "Black"
        case .ultraLight:
            return "UltraLight"
        default:
            return "unknown"
        }
    }
}

public extension CustomFont {
    func attributedString(for text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = {
            var attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.minimumLineHeight = lineHeight
                    style.maximumLineHeight = lineHeight
                    return style
                }(),
            ]

            if let tracking = tracking {
                attrs[.kern] = tracking * font.pointSize
            }

            return attrs
        }()

        return NSAttributedString(string: text, attributes: attributes)
    }
}
