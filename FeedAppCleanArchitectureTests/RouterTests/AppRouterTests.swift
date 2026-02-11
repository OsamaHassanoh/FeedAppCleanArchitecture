//
//  AppRouterTests.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 11/02/2026.
//

import XCTest
@testable import FeedAppCleanArchitecture

@MainActor
final class AppRouterTests: XCTestCase {

    var sut: AppRouter!

    override func setUp() {
        super.setUp()
        sut = AppRouter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialState() {
        XCTAssertEqual(sut.depth, 0)
        XCTAssertNil(sut.currentRoute)
        XCTAssertNil(sut.presentedSheet)
        XCTAssertNil(sut.presentedFullScreen)
    }

    // MARK: - Push Navigation

    func testPushRoute() {
        sut.push(.settings)

        XCTAssertEqual(sut.depth, 1)
        XCTAssertTrue(sut.isCurrentRoute(.settings))
    }

    func testPushMultipleRoutes() {
        sut.push(.settings)

        // Wait past debounce interval
        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.push(.search)

        XCTAssertEqual(sut.depth, 2)
        XCTAssertTrue(sut.isCurrentRoute(.search))
        XCTAssertTrue(sut.contains(.settings))
    }

    func testPushDebounce() {
        sut.push(.settings)
        sut.push(.search) // Should be debounced

        XCTAssertEqual(sut.depth, 1)
        XCTAssertTrue(sut.isCurrentRoute(.settings))
    }

    func testPushDuplicateWithinWindow() {
        sut.push(.settings)

        // Wait past debounce but within duplicate window
        RunLoop.current.run(until: Date().addingTimeInterval(0.35))

        sut.push(.settings) // Same route, should be blocked

        XCTAssertEqual(sut.depth, 1)
    }

    // MARK: - Pop Navigation

    func testPop() {
        sut.push(.settings)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.push(.search)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.pop()

        XCTAssertEqual(sut.depth, 1)
        XCTAssertTrue(sut.isCurrentRoute(.settings))
    }

    func testPopOnEmptyStack() {
        sut.pop()
        XCTAssertEqual(sut.depth, 0)
    }

    func testPopToRoot() {
        sut.push(.settings)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.push(.search)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.popToRoot()

        XCTAssertEqual(sut.depth, 0)
        XCTAssertNil(sut.currentRoute)
    }

    func testPopToRootOnEmptyStack() {
        sut.popToRoot()
        XCTAssertEqual(sut.depth, 0)
    }

    func testPopCount() {
        sut.push(.settings)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.push(.search)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        let post = MockData.mockPost
        sut.push(.postDetail(post: post))

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.pop(count: 2)

        XCTAssertEqual(sut.depth, 1)
        XCTAssertTrue(sut.isCurrentRoute(.settings))
    }

    // MARK: - Modal Navigation

    func testPresentSheet() {
        sut.presentSheet(.settings)

        XCTAssertEqual(sut.presentedSheet, .settings)
    }

    func testDismissSheet() {
        sut.presentSheet(.settings)
        sut.dismissSheet()

        XCTAssertNil(sut.presentedSheet)
    }

    func testPresentFullScreen() {
        let url = URL(string: "https://example.com/image.jpg")!
        sut.presentFullScreen(.imageViewer(imageURL: url, heroTag: "test"))

        XCTAssertNotNil(sut.presentedFullScreen)
    }

    func testDismissFullScreen() {
        let url = URL(string: "https://example.com/image.jpg")!
        sut.presentFullScreen(.imageViewer(imageURL: url, heroTag: "test"))
        sut.dismissFullScreen()

        XCTAssertNil(sut.presentedFullScreen)
    }

    // MARK: - State Queries

    func testContainsRoute() {
        sut.push(.settings)

        XCTAssertTrue(sut.contains(.settings))
        XCTAssertFalse(sut.contains(.search))
    }

    func testIsCurrentRoute() {
        sut.push(.settings)

        XCTAssertTrue(sut.isCurrentRoute(.settings))
        XCTAssertFalse(sut.isCurrentRoute(.search))
    }

    // MARK: - Reset

    func testReset() {
        sut.push(.settings)
        sut.presentSheet(.search)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.reset()

        XCTAssertEqual(sut.depth, 0)
        XCTAssertNil(sut.presentedSheet)
        XCTAssertNil(sut.presentedFullScreen)
    }

    // MARK: - Replace

    func testReplaceRoute() {
        sut.push(.settings)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        sut.replace(with: .search)

        XCTAssertEqual(sut.depth, 1)
        XCTAssertTrue(sut.isCurrentRoute(.search))
        XCTAssertFalse(sut.contains(.settings))
    }

    func testReplaceOnEmptyStackPushesInstead() {
        sut.replace(with: .settings)

        XCTAssertEqual(sut.depth, 1)
        XCTAssertTrue(sut.isCurrentRoute(.settings))
    }

    // MARK: - Route ID

    func testRouteId() {
        let settingsRoute = AppRoute.settings
        XCTAssertEqual(settingsRoute.id, "settings")

        let searchRoute = AppRoute.search
        XCTAssertEqual(searchRoute.id, "search")

        let feedRoute = AppRoute.feed
        XCTAssertEqual(feedRoute.id, "feed")

        let post = MockData.mockPost
        let postRoute = AppRoute.postDetail(post: post)
        XCTAssertEqual(postRoute.id, "postDetail_\(post.id)")

        let user = MockData.mockUser
        let userRoute = AppRoute.userProfile(user: user)
        XCTAssertEqual(userRoute.id, "userProfile_\(user.id)")
    }
}
