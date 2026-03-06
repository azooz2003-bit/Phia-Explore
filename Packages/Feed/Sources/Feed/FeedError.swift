//
//  FeedError.swift
//  Feed
//
//  Created by Abdulaziz Albahar on 3/5/26.
//

import Foundation
import PhiaAPI

enum FeedError: LocalizedError {
    case apiFailure(PhiaAPIError), unknown(any Error)

    var title: String {
        switch self {
        case .apiFailure(let apiError):
            switch apiError {
            case .noHTTPResponseFound, .requestFailed:
                "Connection Error"
            case .clientError:
                "Request Error"
            case .serverError:
                "Server Error"
            case .failedToParseData:
                "Data Error"
            }
        case .unknown:
            "Something Went Wrong"
        }
    }

    var errorDescription: String {
        switch self {
        case .apiFailure(let apiError):
            switch apiError {
            case .noHTTPResponseFound:
                "No response was received from the server. Please check your connection and try again."
            case .requestFailed(let reason):
                "The request failed: \(reason)."
            case .clientError(let statusCode):
                "There was a problem with the request (error \(statusCode)). Please try again."
            case .serverError(let statusCode):
                "The server encountered an error (\(statusCode)). Please try again later."
            case .failedToParseData:
                "We couldn't process the server's response. Please try again."
            }
        case .unknown(let error):
            "An unexpected error occurred: \(error.localizedDescription)."
        }
    }
}
