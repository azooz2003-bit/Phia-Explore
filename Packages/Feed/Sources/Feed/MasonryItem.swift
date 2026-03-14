//
//  MasonryItem.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import Foundation
import PhiaAPI

public enum MasonryItem {
    public enum OutfitVariant {
        case primary(FeedOutfit)
        case secondary(FeedOutfit)
    }

    public enum EditorialVariant {
        case primary(FeedEditorial)
        case secondary(FeedEditorial)
    }

    public enum ProductVariant {
        case primary(FeedProduct)
    }

    case outfit(OutfitVariant)
    case editorial(EditorialVariant)
    case product(ProductVariant)

    public var id: String {
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

    public var cardName: String {
        switch self {
        case .outfit(let variant):
            switch variant {
            case .primary(let outfit), .secondary(let outfit):
                outfit.name
            }
        case .editorial(let variant):
            switch variant {
            case .primary(let editorial), .secondary(let editorial):
                editorial.title
            }
        case .product(let variant):
            switch variant {
            case .primary(let product):
                product.itemName
            }
        }
    }

    public var primaryImageURL: URL? {
        switch self {
        case .outfit(let variant):
            switch variant {
            case .primary(let outfit), .secondary(let outfit):
                outfit.imgUrl ?? outfit.products?.first(where: { $0.imgUrl != nil })?.imgUrl
            }
        case .editorial(let variant):
            switch variant {
            case .primary(let editorial):
                editorial.imgUrl
            case .secondary(let editorial):
                editorial.imgUrl ?? editorial.products?.first(where: { $0.imgUrl != nil })?.imgUrl
            }
        case .product(let variant):
            switch variant {
            case .primary(let product):
                product.imgUrl
            }
        }
    }

    public var hasExpandableImage: Bool {
        primaryImageURL != nil
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
    public static func == (lhs: MasonryItem, rhs: MasonryItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
