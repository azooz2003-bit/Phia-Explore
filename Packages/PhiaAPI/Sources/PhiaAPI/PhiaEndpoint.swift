//
//  PhiaEndpoint.swift
//  PhiaAPI
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation

public enum PhiaEndpoint: Sendable {
    case getPublicExploreFeed(offset: Int = 0, limit: Int = 20)
    case getAuthenticatedExploreFeed(offset: Int = 0, limit: Int = 20)

    /// e.g. /path/to/resource
    var path: String {
        switch self {
        case .getPublicExploreFeed:
            "/explore/feed"
        case .getAuthenticatedExploreFeed:
            "/v2/explore/feed"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPublicExploreFeed:
            .GET
        case .getAuthenticatedExploreFeed:
            .GET
        }
    }

    var queryParams: [URLQueryItem] {
        switch self {
        case .getPublicExploreFeed(let offset, let limit), .getAuthenticatedExploreFeed(let offset, let limit):
            [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
    }
    
    var needsAuthentication: Bool {
        switch self {
        case .getPublicExploreFeed:
            return false
        case .getAuthenticatedExploreFeed:
            return true
        }
    }
}
