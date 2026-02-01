//
//  FeedViewModelTests.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import XCTest
@testable import FeedAppCleanArchitecture

@MainActor
final class FeedViewModelTests: XCTestCase {
    
    var sut: FeedViewModel! // System Under Test
    var mockUseCase: MockFetchFeedsUseCase!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchFeedsUseCase()
        sut = FeedViewModel(fetchFeedsUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialState() {
        // Given - setup in setUp()
        
        // When - initial state
        
        // Then
        XCTAssertEqual(sut.state, .loading, "Initial state should be loading")
        XCTAssertTrue(sut.feeds.isEmpty, "Initial feeds should be empty")
        XCTAssertNil(sut.errorMessage, "Initial error message should be nil")
    }
    
    func testLoadFeedsSuccess() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds
        mockUseCase.shouldReturnError = false
        
        // When
        await sut.loadFeeds()
        
        // Then
        XCTAssertEqual(sut.state, .loaded, "State should be loaded after success")
        XCTAssertEqual(sut.feeds.count, 1, "Should have 1 feed section")
        XCTAssertEqual(sut.feeds.first?.id, "section1", "Feed section ID should match")
        XCTAssertNil(sut.errorMessage, "Error message should be nil on success")
        XCTAssertEqual(mockUseCase.fetchFeedsCallCount, 1, "UseCase should be called once")
    }
    
    func testLoadFeedsFailure() async {
        // Given
        mockUseCase.shouldReturnError = true
        
        // When
        await sut.loadFeeds()
        
        // Then
        XCTAssertEqual(sut.state, .error, "State should be error after failure")
        XCTAssertTrue(sut.feeds.isEmpty, "Feeds should be empty on error")
        XCTAssertNotNil(sut.errorMessage, "Error message should not be nil")
        XCTAssertEqual(mockUseCase.fetchFeedsCallCount, 1, "UseCase should be called once")
    }
    
    func testLoadFeedsMultipleCalls() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds
        
        // When
        await sut.loadFeeds()
        await sut.loadFeeds()
        
        // Then
        XCTAssertEqual(mockUseCase.fetchFeedsCallCount, 2, "UseCase should be called twice")
    }
    
    func testLoadFeedsClearsErrorOnRetry() async {
        // Given - first call fails
        mockUseCase.shouldReturnError = true
        await sut.loadFeeds()
        XCTAssertNotNil(sut.errorMessage, "Should have error message")
        
        // When - retry with success
        mockUseCase.shouldReturnError = false
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()
        
        // Then
        XCTAssertNil(sut.errorMessage, "Error should be cleared on retry")
        XCTAssertEqual(sut.state, .loaded, "State should be loaded")
    }
}
