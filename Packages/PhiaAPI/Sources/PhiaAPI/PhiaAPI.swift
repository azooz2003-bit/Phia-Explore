//
//  PhiaAPI.swift
//  PhiaAPI
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation

public struct PhiaAPI: Sendable {
    /// User-friendly errors for PhiaAPI
    public enum PhiaAPIError: LocalizedError, Sendable {
        case noHTTPResponseFound
        case requestFailed(reason: String)
        case clientError(statusCode: Int)
        case serverError(statusCode: Int)
        case failedToParseData
    }

    static let baseURL = URL(string: "http://35.193.245.204/api")!

    let authToken = "phia-interview-token"
    let decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()

    public init() {}

    public func request(for endpoint: PhiaEndpoint) -> URLRequest {
        let url = Self.baseURL
            .appending(path: endpoint.path)
            .appending(queryItems: endpoint.queryParams)

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        var headers: [String: String] = [
            "Accept" : "application/json"
        ]

        if endpoint.needsAuthentication {
            headers["Authorization"] = "Bearer \(authToken)"
        }

        request.allHTTPHeaderFields = headers

        return request
    }

    public func dispatchRequest<T: Decodable>(
        for endpoint: PhiaEndpoint
    ) async throws(PhiaAPIError) -> T {
        let request = self.request(for: endpoint)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw PhiaAPIError.requestFailed(reason: error.localizedDescription)
        }

        guard let response = response as? HTTPURLResponse else {
            throw PhiaAPIError.noHTTPResponseFound
        }

        let httpStatus = HTTPStatusCode(rawValue: response.statusCode)

        guard httpStatus?.responseType == .success else {
            guard let httpStatus else {
                throw PhiaAPIError.requestFailed(reason: "Request did not succeed, \(response.statusCode)")
            }

            switch httpStatus.responseType {
            case .clientError:
                throw PhiaAPIError.clientError(statusCode: response.statusCode)
            case .serverError:
                throw PhiaAPIError.serverError(statusCode: response.statusCode)
            default:
                throw PhiaAPIError.requestFailed(reason: "Request did not succeed, \(response.statusCode)")
            }
        }


        guard let decoded = try? decoder.decode(T.self, from: data) else {
            throw PhiaAPIError.failedToParseData
        }

        return decoded
    }
}

public typealias PhiaAPIError = PhiaAPI.PhiaAPIError
