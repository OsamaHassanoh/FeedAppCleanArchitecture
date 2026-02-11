//
//  MockFetchFeedsUseCase.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import Foundation
@testable import FeedAppCleanArchitecture

final class MockFetchFeedsUseCase: FetchFeedsUseCaseProtocol, @unchecked Sendable {
    var shouldReturnError = false
    var mockFeeds: [FeedSectionEntity] = []
    var executeCallCount = 0

    func execute() async throws -> [FeedSectionEntity] {
        executeCallCount += 1

        if shouldReturnError {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }

        return mockFeeds
    }
}
