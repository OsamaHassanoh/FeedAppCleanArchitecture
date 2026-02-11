//
//  FeedResponseDTO.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

// MARK: - Root

struct FeedResponseDTO: Codable {
    let data: [FeedSectionDTO]
}

// MARK: - Section

struct FeedSectionDTO: Codable, Identifiable {
    let id: String
    let title: String
    let posts: [PostDTO]
}

// MARK: - Post

struct PostDTO: Codable, Identifiable {
    let id: String
    let user: UserDTO
    let imageURL: String
    let caption: String
    let likesCount: Int
    let commentsCount: Int
    let isLiked: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case imageURL = "image_url"
        case caption
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case isLiked = "is_liked"
        case createdAt = "created_at"
    }
}

// MARK: - User

struct UserDTO: Codable, Identifiable {
    let id: String
    let username: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profileImageURL = "profile_image_url"
    }
}
