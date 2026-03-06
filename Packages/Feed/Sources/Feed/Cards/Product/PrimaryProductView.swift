//
//  PrimaryProductView.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import SwiftUI
import DesignSystem
import PhiaAPI

struct PrimaryProductView: View {
    static let estimatedHeight: CGFloat = 352

    let product: FeedProduct

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    /// Displays brand and price (not formatted since price amount is only provided in US dollars)
    var subtitle: String {
        let priceFormatted = formatter.string(for: product.price)
        if let priceFormatted {
            return "\(product.brand.uppercased()) • \(priceFormatted)"
        } else { return product.brand }
    }

    var body: some View {
        GenericItemCard(title: product.itemName, titleLineLimit: 2, subtitle: subtitle, imageUrls: [product.imgUrl].compactMap(\.self))
    }
}

#Preview {
    FontManager.registerFonts()

    return VStack(alignment: .center) {
        PrimaryProductView(product: .primaryPreview)
            .frame(width: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.tertiary)
}
