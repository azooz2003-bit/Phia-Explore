//
//  PhiaAPITests.swift
//  PhiaAPI
//
//  Created by Abdulaziz Albahar on 3/4/26.
//

import Testing
@testable import PhiaAPI

struct PhiaAPITests {

    let api = PhiaAPI()

    @Test func testAPICallDoesntThrow() async throws {
        let response = try await api.dispatchRequest(for: .getPublicExploreFeed(offset: 0, limit: 20)) as ExploreFeedResponse

        print(response)
    }
}
