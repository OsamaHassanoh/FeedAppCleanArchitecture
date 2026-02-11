//
//  DeepLinkHandlerTests.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 11/02/2026.
//

import XCTest
@testable import FeedAppCleanArchitecture

@MainActor
final class DeepLinkHandlerTests: XCTestCase {

    var router: AppRouter!

    override func setUp() {
        super.setUp()
        router = AppRouter()
    }

    override func tearDown() {
        router = nil
        super.tearDown()
    }

    func testHandlePostDeepLink() {
        let url = URL(string: "feedapp://post/123")!
        DeepLinkHandler.handle(url, router: router)

        XCTAssertEqual(router.depth, 1)
        if let currentRoute = router.currentRoute,
           case .postDetail(let post) = currentRoute {
            XCTAssertEqual(post.id, "123")
        } else {
            XCTFail("Expected postDetail route")
        }
    }

    func testHandleUserDeepLink() {
        let url = URL(string: "feedapp://user/john_doe")!
        DeepLinkHandler.handle(url, router: router)

        XCTAssertEqual(router.depth, 1)
        if let currentRoute = router.currentRoute,
           case .userProfile(let user) = currentRoute {
            XCTAssertEqual(user.username, "john_doe")
        } else {
            XCTFail("Expected userProfile route")
        }
    }

    func testHandleFeedDeepLink() {
        // Push a route first
        router.push(.settings)
        XCTAssertEqual(router.depth, 1)

        RunLoop.current.run(until: Date().addingTimeInterval(0.4))

        let url = URL(string: "feedapp://feed")!
        DeepLinkHandler.handle(url, router: router)

        XCTAssertEqual(router.depth, 0)
    }

    func testHandleSearchDeepLink() {
        let url = URL(string: "feedapp://search")!
        DeepLinkHandler.handle(url, router: router)

        XCTAssertEqual(router.depth, 1)
        XCTAssertTrue(router.isCurrentRoute(.search))
    }

    func testHandleSettingsDeepLink() {
        let url = URL(string: "feedapp://settings")!
        DeepLinkHandler.handle(url, router: router)

        XCTAssertEqual(router.depth, 1)
        XCTAssertTrue(router.isCurrentRoute(.settings))
    }

    func testHandleUnknownDeepLink() {
        let url = URL(string: "feedapp://unknown")!
        DeepLinkHandler.handle(url, router: router)

        XCTAssertEqual(router.depth, 0)
    }

    func testHandleInvalidURL() {
        let url = URL(string: "https://example.com")!
        DeepLinkHandler.handle(url, router: router)

        // https URLs have host "example.com" which is unknown, so no navigation
        XCTAssertEqual(router.depth, 0)
    }
}
