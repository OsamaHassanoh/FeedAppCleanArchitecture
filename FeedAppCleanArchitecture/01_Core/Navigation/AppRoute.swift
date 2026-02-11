//
//  AppRoute.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//

import Foundation

enum AppRoute: Hashable, Identifiable, Sendable {
    case feed
    case postDetail(post: PostEntity)
    case userProfile(user: UserEntity)
    case imageViewer(imageURL: URL, heroTag: String)
    case settings
    case search

    var id: String {
        switch self {
        case .feed:
            return "feed"
        case .postDetail(let post):
            return "postDetail_\(post.id)"
        case .userProfile(let user):
            return "userProfile_\(user.id)"
        case .imageViewer(_, let heroTag):
            return "imageViewer_\(heroTag)"
        case .settings:
            return "settings"
        case .search:
            return "search"
        }
    }
}

// MARK: - Entity Hashable Conformance

extension PostEntity: Hashable {
    static func == (lhs: PostEntity, rhs: PostEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension UserEntity: Hashable {
    static func == (lhs: UserEntity, rhs: UserEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
