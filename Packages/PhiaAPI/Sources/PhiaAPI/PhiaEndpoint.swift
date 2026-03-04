//
//  PhiaEndpoint.swift
//  PhiaAPI
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation

public enum PhiaEndpoint {
    case publicExploreFeed(offset: Int = 0, limit: Int = 20)
    case authenticatedExploreFeed(offset: Int = 0, limit: Int = 20)

    /// e.g. /path/to/resource
    var path: String {
        switch self {
        case .publicExploreFeed:
            "/explore/feed"
        case .authenticatedExploreFeed:
            "/api/v2/explore/feed"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .publicExploreFeed:
            .GET
        case .authenticatedExploreFeed:
            .GET
        }
    }

    var queryParams: [URLQueryItem] {
        switch self {
        case .publicExploreFeed(let offset, let limit), .authenticatedExploreFeed(let offset, let limit):
            [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
    }
    
    var needsAuthentication: Bool {
        switch self {
        case .publicExploreFeed:
            return false
        case .authenticatedExploreFeed:
            return true
        }
    }
}
