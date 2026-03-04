//
//  ExploreFeedResponse.swift
//  PhiaAPI
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation

public struct ExploreFeedResponse: Decodable, Sendable {
    public struct ExploreFeedSection: Decodable, Sendable {
        public enum SectionType: String, Decodable, Sendable {
            case feed = "FEED"
        }

        public enum ComponentType: String, Decodable, Sendable {
            case header = "HEADER", masonry = "MASONRY", moduleCarousel = "MODULE_CAROUSEL", moduleCarouselPrevViewed = "MODULE_CAROUSEL_PREV_VIEWED"
        }

        public struct SectionData: Decodable, Sendable {
            public struct FeedItem: Decodable, Sendable {
                public enum EntityType: String, Decodable, Sendable {
                    case product = "ENTITY_TYPE_PRODUCT", outfit = "ENTITY_TYPE_OUTFIT", editorial = "ENTITY_TYPE_EDITORIAL"
                }

                public enum FeedItemVariant: String, Decodable, Sendable {
                    case primary = "PRIMARY", secondary = "SECONDARY", tertiary = "TERTIARY"
                }

                public struct ProductOutput: Decodable, Sendable {
                    public let id: String
                    public let itemName: String
                    public let brand: String
                    public let price: Double
                    public let productUrl: URL
                    public let imgUrl: URL?
                }

                public struct AuthorOutput: Decodable, Sendable {
                    public let id: String
                    public let name: String
                    public let handle: String
                    public let imgUrl: URL?
                }

                public struct BrandOutput: Decodable, Sendable {
                    public let id: String
                    public let displayName: String
                    public let description: String?
                    public let websiteUrl: URL?
                    public let logoUrl: URL?
                }

                public struct OutfitOutput: Decodable, Sendable {
                    public let id: String
                    public let name: String
                    public let description: String?
                    public let imgUrl: URL?
                    public let imgUrls: [URL]?
                    public let author: AuthorOutput?
                    public let brand: BrandOutput?
                    public let products: [ProductOutput]?
                }

                public struct EditorialOutput: Decodable, Sendable {
                    public let id: String
                    public let collectionId: String
                    public let title: String
                    public let description: String?
                    public let imgUrl: URL?
                    public let author: AuthorOutput?
                    public let brand: BrandOutput?
                    public let products: [ProductOutput]?
                }

                public let id: String
                public let entityType: EntityType
                public let variant: FeedItemVariant?
                public let product: ProductOutput?
                public let outfit: OutfitOutput?
                public let editorial: EditorialOutput?
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

// MARK: - Public Type Aliases

public typealias ExploreFeedSection = ExploreFeedResponse.ExploreFeedSection
public typealias FeedSectionType = ExploreFeedResponse.ExploreFeedSection.SectionType
public typealias FeedComponentType = ExploreFeedResponse.ExploreFeedSection.ComponentType
public typealias FeedSectionData = ExploreFeedResponse.ExploreFeedSection.SectionData
public typealias FeedItem = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem
public typealias FeedEntityType = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem.EntityType
public typealias FeedItemVariant = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem.FeedItemVariant
public typealias FeedProduct = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem.ProductOutput
public typealias FeedAuthor = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem.AuthorOutput
public typealias FeedBrand = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem.BrandOutput
public typealias FeedOutfit = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem.OutfitOutput
public typealias FeedEditorial = ExploreFeedResponse.ExploreFeedSection.SectionData.FeedItem.EditorialOutput
