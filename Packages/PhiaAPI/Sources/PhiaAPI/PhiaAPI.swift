//
//  PhiaAPI.swift
//  PhiaAPI
//
//  Created by Abdulaziz Albahar on 3/3/26.
//

import Foundation

public struct PhiaAPI: Sendable {
    /// User-friendly errors for PhiaAPI
    public enum PhiaAPIError: LocalizedError {
        case noHTTPResponseFound, requestFailed, clientError, serverError, failedToParseData
    }

    static let baseURL = URL(string: "http://35.193.245.204")!

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

        let headers: [String: String] = [
            "Accept" : "application/json"
        ]

        if endpoint.needsAuthentication {
            request.allHTTPHeaderFields?["Authorization"] = "Bearer \(authToken)"
        }

        request.allHTTPHeaderFields = headers

        return request
    }

    public func dispatchRequest<T: Decodable>(
        for endpoint: PhiaEndpoint
    ) async throws(PhiaAPIError) -> T {
        let request = self.request(for: endpoint)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw PhiaAPIError.noHTTPResponseFound
            }

            let httpStatus = HTTPStatusCode(rawValue: response.statusCode)

            guard httpStatus?.responseType == .success else {
                guard let httpStatus else {
                    throw PhiaAPIError.requestFailed
                }

                switch httpStatus.responseType {
                case .clientError:
                    throw PhiaAPIError.clientError
                case .serverError:
                    throw PhiaAPIError.serverError
                default:
                    throw PhiaAPIError.requestFailed
                }
            }

            
            guard let decoded = try? decoder.decode(T.self, from: data) else {
                throw PhiaAPIError.failedToParseData
            }

            return decoded
        } catch {
            throw PhiaAPIError.requestFailed
        }
    }
}

public typealias PhiaAPIError = PhiaAPI.PhiaAPIError
