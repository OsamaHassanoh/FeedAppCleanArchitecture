//
//  FeedEntity.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

struct FeedSectionEntity: Identifiable, Sendable {
    let id: String
    let title: String
    let posts: [PostEntity]
}

struct PostEntity: Identifiable, Sendable {
    let id: String
    let user: UserEntity
    let imageURL: URL
    let caption: String
    let likesCount: Int
    let commentsCount: Int
    let isLiked: Bool
    let createdAt: Date
}

struct UserEntity: Identifiable, Sendable {
    let id: String
    let username: String
    let profileImageURL: URL
}
