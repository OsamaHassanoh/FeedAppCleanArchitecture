//
//  MockFeedRepository.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import Foundation
@testable import FeedAppCleanArchitecture

final class MockFeedRepository: FeedRepoProtocol {
    // Control test behavior
    var shouldReturnError = false
    var mockFeeds: [FeedSectionEntity] = []
    var fetchFeedsCallCount = 0
    
    func fetchFeeds() async throws -> [FeedSectionEntity] {
        fetchFeedsCallCount += 1
        
        if shouldReturnError {
            throw NSError(domain: "TestError", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Mock error"
            ])
        }
        
        return mockFeeds
    }
}
