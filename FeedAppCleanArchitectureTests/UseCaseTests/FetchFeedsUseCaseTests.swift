//
//  FetchFeedsUseCaseTests.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import XCTest
@testable import FeedAppCleanArchitecture

final class FetchFeedsUseCaseTests: XCTestCase {
    
    var sut: FetchFeedsUseCase!
    var mockRepository: MockFeedRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockFeedRepository()
        sut = FetchFeedsUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchFeedsSuccess() async throws {
        // Given
        mockRepository.mockFeeds = MockData.mockFeeds
        mockRepository.shouldReturnError = false
        
        // When
        let feeds = try await sut.fetchFeeds()
        
        // Then
        XCTAssertEqual(feeds.count, 1, "Should return 1 feed section")
        XCTAssertEqual(feeds.first?.title, "For You")
        XCTAssertEqual(mockRepository.fetchFeedsCallCount, 1)
    }
    
    func testFetchFeedsFailure() async {
        // Given
        mockRepository.shouldReturnError = true
        
        // When/Then
        do {
            _ = try await sut.fetchFeeds()
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error, "Should have error")
            XCTAssertEqual(mockRepository.fetchFeedsCallCount, 1)
        }
    }
}
