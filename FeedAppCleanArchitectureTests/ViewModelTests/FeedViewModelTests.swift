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

    var sut: FeedViewModel!
    var mockUseCase: MockFetchFeedsUseCase!
    var router: AppRouter!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchFeedsUseCase()
        router = AppRouter()
        sut = FeedViewModel(fetchFeedsUseCase: mockUseCase, router: router)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        router = nil
        super.tearDown()
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        XCTAssertEqual(sut.state, .loading, "Initial state should be loading")
        XCTAssertTrue(sut.feeds.isEmpty, "Initial feeds should be empty")
        XCTAssertEqual(sut.selectedSectionIndex, 0, "Initial selected section index should be 0")
        XCTAssertNil(sut.selectedSection, "Initial selected section should be nil")
    }

    // MARK: - Load Feeds Tests

    func testLoadFeedsSuccess() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds
        mockUseCase.shouldReturnError = false

        // When
        await sut.loadFeeds()

        // Then
        if case .loaded(let feeds) = sut.state {
            XCTAssertEqual(feeds.count, 1, "Should have 1 feed section")
            XCTAssertEqual(feeds.first?.id, "section1", "Feed section ID should match")
        } else {
            XCTFail("State should be .loaded after successful fetch")
        }
        XCTAssertEqual(sut.feeds.count, 1, "Feeds computed property should return 1 section")
        XCTAssertEqual(mockUseCase.executeCallCount, 1, "UseCase should be called once")
    }

    func testLoadFeedsFailure() async {
        // Given
        mockUseCase.shouldReturnError = true

        // When
        await sut.loadFeeds()

        // Then
        if case .error(let message) = sut.state {
            XCTAssertFalse(message.isEmpty, "Error message should not be empty")
        } else {
            XCTFail("State should be .error after failed fetch")
        }
        XCTAssertTrue(sut.feeds.isEmpty, "Feeds should be empty on error")
        XCTAssertEqual(mockUseCase.executeCallCount, 1, "UseCase should be called once")
    }

    func testLoadFeedsEmptyResult() async {
        // Given
        mockUseCase.mockFeeds = []
        mockUseCase.shouldReturnError = false

        // When
        await sut.loadFeeds()

        // Then
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, "No feeds available", "Should show 'No feeds available' for empty result")
        } else {
            XCTFail("State should be .error when feeds are empty")
        }
    }

    func testLoadFeedsMultipleCalls() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds

        // When
        await sut.loadFeeds()
        await sut.loadFeeds()

        // Then
        XCTAssertEqual(mockUseCase.executeCallCount, 2, "UseCase should be called twice")
    }

    func testLoadFeedsClearsErrorOnRetry() async {
        // Given - first call fails
        mockUseCase.shouldReturnError = true
        await sut.loadFeeds()
        if case .error = sut.state {} else {
            XCTFail("State should be error after failed fetch")
        }

        // When - retry with success
        mockUseCase.shouldReturnError = false
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()

        // Then
        if case .loaded = sut.state {} else {
            XCTFail("State should be loaded after successful retry")
        }
    }

    // MARK: - Refresh Tests

    func testRefreshFeedsSuccess() async {
        // Given - load initial data
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()

        // When - refresh
        await sut.refreshFeeds()

        // Then
        if case .loaded(let feeds) = sut.state {
            XCTAssertEqual(feeds.count, 1)
        } else {
            XCTFail("State should remain loaded after refresh")
        }
        XCTAssertEqual(mockUseCase.executeCallCount, 2)
    }

    func testRefreshFeedsKeepsDataOnError() async {
        // Given - load initial data
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()

        // When - refresh fails
        mockUseCase.shouldReturnError = true
        await sut.refreshFeeds()

        // Then - should keep existing data
        if case .loaded(let feeds) = sut.state {
            XCTAssertEqual(feeds.count, 1, "Should keep existing data on refresh error")
        } else {
            XCTFail("State should remain loaded when refresh fails with existing data")
        }
    }

    // MARK: - Section Selection Tests

    func testSelectSection() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()

        // When
        sut.selectSection(at: 0)

        // Then
        XCTAssertEqual(sut.selectedSectionIndex, 0)
        XCTAssertNotNil(sut.selectedSection)
    }

    func testSelectSectionOutOfBounds() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()

        // When
        sut.selectSection(at: 99)

        // Then - should remain at 0
        XCTAssertEqual(sut.selectedSectionIndex, 0)
    }

    func testSelectSectionNegativeIndex() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()

        // When
        sut.selectSection(at: -1)

        // Then
        XCTAssertEqual(sut.selectedSectionIndex, 0)
    }

    // MARK: - Navigation Tests

    func testNavigateToPostDetail() async {
        // Given
        mockUseCase.mockFeeds = MockData.mockFeeds
        await sut.loadFeeds()

        // When
        sut.navigateToPostDetail(MockData.mockPost)

        // Then
        XCTAssertEqual(router.depth, 1, "Router should have 1 route after navigation")
        XCTAssertTrue(router.isCurrentRoute(.postDetail(post: MockData.mockPost)))
    }

    func testNavigateToUserProfile() {
        // When
        sut.navigateToUserProfile(MockData.mockUser)

        // Then
        XCTAssertEqual(router.depth, 1)
        XCTAssertTrue(router.isCurrentRoute(.userProfile(user: MockData.mockUser)))
    }

    func testNavigateToSearch() {
        // When
        sut.navigateToSearch()

        // Then
        XCTAssertEqual(router.depth, 1)
        XCTAssertTrue(router.isCurrentRoute(.search))
    }

    func testNavigateToSettings() {
        // When
        sut.navigateToSettings()

        // Then
        XCTAssertEqual(router.depth, 1)
        XCTAssertTrue(router.isCurrentRoute(.settings))
    }
}
