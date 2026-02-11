//
//  FeedMapperTests.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import XCTest
@testable import FeedAppCleanArchitecture

final class FeedMapperTests: XCTestCase {
    
    func testMapFeedResponseDTO() {
        // Given
        let dto = MockData.mockFeedResponseDTO
        
        // When
        let entities = FeedMapper.map(dto)
        
        // Then
        XCTAssertEqual(entities.count, 1, "Should map 1 section")
        XCTAssertEqual(entities.first?.id, "section1")
        XCTAssertEqual(entities.first?.title, "For You")
        XCTAssertEqual(entities.first?.posts.count, 1)
    }
    
    func testMapPostDTO() {
        // Given
        let dto = MockData.mockFeedResponseDTO
        
        // When
        let entities = FeedMapper.map(dto)
        let post = entities.first?.posts.first
        
        // Then
        XCTAssertEqual(post?.id, "post1")
        XCTAssertEqual(post?.caption, "Test caption")
        XCTAssertEqual(post?.likesCount, 42)
        XCTAssertEqual(post?.commentsCount, 5)
        XCTAssertFalse(post?.isLiked ?? true)
    }
    
    func testMapUserDTO() {
        // Given
        let dto = MockData.mockFeedResponseDTO
        
        // When
        let entities = FeedMapper.map(dto)
        let user = entities.first?.posts.first?.user
        
        // Then
        XCTAssertEqual(user?.id, "user1")
        XCTAssertEqual(user?.username, "testuser")
        XCTAssertNotNil(user?.profileImageURL)
    }
    
    func testMapEmptyDTO() {
        // Given
        let dto = FeedResponseDTO(data: [])
        
        // When
        let entities = FeedMapper.map(dto)
        
        // Then
        XCTAssertTrue(entities.isEmpty, "Should return empty array")
    }
}
