//
//  FeedMapper.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

enum FeedMapper {
    static func map(_ dto: FeedResponseDTO) -> [FeedSectionEntity] {
        dto.data.map { section in
            FeedSectionEntity(
                id: section.id,
                title: section.title,
                posts: section.posts.map(map)
            )
        }
    }

    private static func map(_ dto: PostDTO) -> PostEntity {
        PostEntity(
            id: dto.id,
            user: map(dto.user),
            imageURL: URL(string: dto.imageURL) ?? URL(string: "")!,
            caption: dto.caption,
            likesCount: dto.likesCount,
            commentsCount: dto.commentsCount,
            isLiked: dto.isLiked,
            createdAt: ISO8601DateFormatter().date(from: dto.createdAt) ?? Date()
        )
    }

    private static func map(_ dto: UserDTO) -> UserEntity {
        UserEntity(
            id: dto.id,
            username: dto.username,
            profileImageURL: URL(string: dto.profileImageURL) ?? URL(string: "")!
        )
    }
}
