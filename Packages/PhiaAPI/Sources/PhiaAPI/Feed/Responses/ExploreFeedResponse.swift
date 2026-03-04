//
//  ExploreFeedResponse.swift
//  PhiaAPI
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation

public struct ExploreFeedResponse: Decodable {
    public struct ExploreFeedSection: Decodable {
        public enum SectionType: String, Decodable {
            case feed = "FEED"
        }

        public enum ComponentType: String, Decodable {
            case header = "HEADER", masonry = "MASONRY", moduleCarousel = "MODULE_CAROUSEL", moduleCarouselPrevViewed = "MODULE_CAROUSEL_PREV_VIEWED"
        }

        public struct SectionData: Decodable {
            public struct FeedItem: Decodable {
                public enum EntityType: String, Decodable {
                    case product = "ENTITY_TYPE_PRODUCT", outfit = "ENTITY_TYPE_OUTFIT", editorial = "ENTITY_TYPE_EDITORIAL"
                }

                public enum FeedItemVariant: String, Decodable {
                    case primary = "PRIMARY", secondary = "SECONDARY", tertiary = "TERTIARY"
                }

                public struct ProductOutput: Decodable {
                    let id: String
                    let itemName: String
                    let brand: String
                    let price: Double
                    let productUrl: URL
                    let imgUrl: URL?
                }

                public struct AuthorOutput: Decodable {
                    let id: String
                    let name: String
                    let handle: String
                    let imgUrl: URL?
                }

                public struct BrandOutput: Decodable {
                    let id: String
                    let displayName: String
                    let description: String?
                    let websiteUrl: URL?
                    let logoUrl: URL?
                }

                public struct OutfitOutput: Decodable {
                    let id: String
                    let name: String
                    let description: String?
                    let imgUrl: URL?
                    let imgUrls: [URL]?
                    let author: AuthorOutput?
                    let brand: BrandOutput?
                    let products: [ProductOutput]?
                }

                public struct EditorialOutput: Decodable {
                    let id: String
                    let collectionId: String
                    let title: String
                    let description: String?
                    let imgUrl: URL?
                    let author: AuthorOutput?
                    let brand: BrandOutput?
                    let products: [ProductOutput]?
                }

                public let id: String
                public let entityType: EntityType
                public let variant: FeedItemVariant?
                public let product: ProductOutput?
                public let outfit: OutfitOutput?
                public let editorial: EditorialOutput?
                // TODO:
            }

            public let items: [FeedItem]
            public let title: String?
            public let subtitle: String?
        }

        public let id: String
        public let type: SectionType?
        public let componentType: ComponentType
        public let data: SectionData
    }

    public let sections: [ExploreFeedSection]
    public let hasMore: Bool
    public let offset: Int?
}
