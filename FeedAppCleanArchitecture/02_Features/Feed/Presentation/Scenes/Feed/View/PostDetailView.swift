//
//  PostDetailView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    @EnvironmentObject private var router: AppRouter
    let post: PostEntity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                KFImage(post.imageURL)
                    .placeholder {
                        SkeletonRect(
                            height: UIScreen.main.bounds.width,
                            cornerRadius: 0
                        )
                    }
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        router.push(.userProfile(user: post.user))
                    } label: {
                        HStack {
                            KFImage(post.user.profileImageURL)
                                .placeholder { SkeletonCircle(size: 48) }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(post.user.username)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)

                                Text(formatDate(post.createdAt))
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                    }

                    HStack(spacing: 24) {
                        Label(
                            "\(post.likesCount) likes",
                            systemImage: post.isLiked ? "heart.fill" : "heart"
                        )
                        .foregroundColor(post.isLiked ? .red : .primary)
                        .font(.system(size: 16, weight: .semibold))

                        Label(
                            "\(post.commentsCount) comments",
                            systemImage: "bubble.right"
                        )
                        .foregroundColor(.primary)
                        .font(.system(size: 16))
                    }

                    Divider()

                    Text(post.user.username)
                        .font(.system(size: 15, weight: .semibold))
                    +
                    Text(" ")
                    +
                    Text(post.caption)
                        .font(.system(size: 15))
                }
                .padding(16)
            }
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
