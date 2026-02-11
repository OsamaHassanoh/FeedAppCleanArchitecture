//
//  FeedRepositoryTests.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import XCTest
@testable import FeedAppCleanArchitecture

final class FeedRepositoryTests: XCTestCase {
    
    var sut: FeedRepository!
    var mockNetwork: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkService()
        sut = FeedRepository(network: mockNetwork)
    }
    
    override func tearDown() {
        sut = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testFetchFeedsSuccess() async throws {
        // Given
        mockNetwork.mockResponse = MockData.mockFeedResponseDTO
        mockNetwork.shouldReturnError = false
        
        // When
        let feeds = try await sut.fetchFeeds()
        
        // Then
        XCTAssertEqual(feeds.count, 1, "Should return 1 feed section")
        XCTAssertEqual(feeds.first?.title, "For You")
        XCTAssertEqual(feeds.first?.posts.count, 1)
        XCTAssertEqual(mockNetwork.callModelCallCount, 1)
    }
    
    func testFetchFeedsNetworkError() async {
        // Given
        mockNetwork.shouldReturnError = true
        
        // When/Then
        do {
            _ = try await sut.fetchFeeds()
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
            XCTAssertEqual(mockNetwork.callModelCallCount, 1)
        }
    }
}
