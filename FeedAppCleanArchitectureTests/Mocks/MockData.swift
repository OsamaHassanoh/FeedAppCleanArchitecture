//
//  MockData.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import Foundation
@testable import FeedAppCleanArchitecture

enum MockData {
    // MARK: - Entities
    
    static let mockUser = UserEntity(
        id: "user1",
        username: "testuser",
        profileImageURL: URL(string: "https://example.com/profile.jpg")!
    )
    
    static let mockPost = PostEntity(
        id: "post1",
        user: mockUser,
        imageURL: URL(string: "https://example.com/image.jpg")!,
        caption: "Test caption",
        likesCount: 42,
        commentsCount: 5,
        isLiked: false,
        createdAt: Date()
    )
    
    static let mockFeedSection = FeedSectionEntity(
        id: "section1",
        title: "For You",
        posts: [mockPost]
    )
    
    static let mockFeeds = [mockFeedSection]
    
    // MARK: - DTOs
    
    static let mockUserDTO = UserDTO(
        id: "user1",
        username: "testuser",
        profileImageURL: "https://example.com/profile.jpg"
    )
    
    static let mockPostDTO = PostDTO(
        id: "post1",
        user: mockUserDTO,
        imageURL: "https://example.com/image.jpg",
        caption: "Test caption",
        likesCount: 42,
        commentsCount: 5,
        isLiked: false,
        createdAt: "2024-01-29T10:00:00Z"
    )
    
    static let mockFeedSectionDTO = FeedSectionDTO(
        id: "section1",
        title: "For You",
        posts: [mockPostDTO]
    )
    
    static let mockFeedResponseDTO = FeedResponseDTO(
        data: [mockFeedSectionDTO]
    )
}
