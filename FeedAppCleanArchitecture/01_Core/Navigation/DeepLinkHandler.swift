//
//  DeepLinkHandler.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//

import Foundation

struct DeepLinkHandler {

    private enum Defaults {
        // swiftlint:disable:next force_unwrapping
        static let placeholderImageSmall = URL(string: "https://via.placeholder.com/150")!
        // swiftlint:disable:next force_unwrapping
        static let placeholderImageLarge = URL(string: "https://via.placeholder.com/600")!
    }

    static func handle(_ url: URL, router: AppRouter) {
        guard let host = url.host else { return }

        switch host {
        case "post":
            let postId = url.lastPathComponent
            guard !postId.isEmpty, postId != "/" else { return }
            navigateToPost(postId: postId, router: router)

        case "user":
            let username = url.lastPathComponent
            guard !username.isEmpty, username != "/" else { return }
            navigateToUser(username: username, router: router)

        case "feed":
            router.popToRoot()

        case "search":
            router.push(.search)

        case "settings":
            router.push(.settings)

        default:
            break
        }
    }

    private static func navigateToPost(postId: String, router: AppRouter) {
        let user = UserEntity(
            id: "unknown",
            username: "Loading...",
            profileImageURL: Defaults.placeholderImageSmall
        )
        let post = PostEntity(
            id: postId,
            user: user,
            imageURL: Defaults.placeholderImageLarge,
            caption: "",
            likesCount: 0,
            commentsCount: 0,
            isLiked: false,
            createdAt: Date()
        )
        router.push(.postDetail(post: post))
    }

    private static func navigateToUser(username: String, router: AppRouter) {
        let user = UserEntity(
            id: username,
            username: username,
            profileImageURL: Defaults.placeholderImageSmall
        )
        router.push(.userProfile(user: user))
    }
}
