//
//  MasonryItem.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import Foundation
import PhiaAPI

enum MasonryItem {
    enum OutfitVariant {
        case primary(FeedOutfit), secondary(FeedOutfit)
    }

    enum EditorialVariant {
        case primary(FeedEditorial), secondary(FeedEditorial)
    }

    enum ProductVariant {
        case primary(FeedProduct)
    }

    case outfit(OutfitVariant), editorial(EditorialVariant), product(ProductVariant)

    var id: String {
        switch self {
        case .outfit(let outfitVariant):
            switch outfitVariant {
            case .primary(let outfit), .secondary(let outfit):
                outfit.id
            }
        case .editorial(let editorialVariant):
            switch editorialVariant {
            case .primary(let editorial), .secondary(let editorial):
                editorial.id
            }
        case .product(let productVariant):
            switch productVariant {
            case .primary(let product):
                product.id
            }
        }
    }
    
    var estimatedHeight: CGFloat {
        switch self {
        case .outfit(let outfitVariant):
            switch outfitVariant {
            case .primary:
                PrimaryOutfitCard.estimatedHeight
            case .secondary:
                SecondaryOutfitCard.estimatedHeight
            }
        case .editorial(let editorialVariant):
            switch editorialVariant {
            case .primary:
                PrimaryEditorialCard.estimatedHeight
            case .secondary:
                SecondaryEditorialCard.estimatedHeight
            }
        case .product(let productVariant):
            switch productVariant {
            case .primary:
                PrimaryProductCard.estimatedHeight
            }
        }
    }

    init?(fromResponse item: FeedItem) {
        switch item.entityType {
        case .editorial:
            guard let editorial = item.editorial else { return nil }
            switch item.variant {
            case .primary:
                self = .editorial(.primary(editorial))
            case .secondary:
                self = .editorial(.secondary(editorial))
            default:
                return nil
            }
        case .product:
            guard let product = item.product else { return nil }
            switch item.variant {
            case .primary:
                self = .product(.primary(product))
            default:
                return nil
            }
        case .outfit:
            guard let outfit = item.outfit else { return nil }
            switch item.variant {
            case .primary:
                self = .outfit(.primary(outfit))
            case .secondary:
                self = .outfit(.secondary(outfit))
            default:
                return nil
            }
        }
    }
    // TODO: HANDLE ALL SECTIONs if there's time
}

extension MasonryItem: Identifiable {}

extension MasonryItem: Hashable {
    static func == (lhs: MasonryItem, rhs: MasonryItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
