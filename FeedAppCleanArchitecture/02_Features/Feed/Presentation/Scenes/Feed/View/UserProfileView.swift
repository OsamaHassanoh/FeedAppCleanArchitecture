//
//  UserProfileView.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//

import SwiftUI
import Kingfisher

struct UserProfileView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var isFollowing = false
    let user: UserEntity

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                KFImage(user.profileImageURL)
                    .placeholder { SkeletonCircle(size: 100) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

                Text(user.username)
                    .font(.title)
                    .fontWeight(.bold)

                Text("ID: \(user.id)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFollowing.toggle()
                    }
                } label: {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.headline)
                        .foregroundColor(isFollowing ? .primary : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isFollowing ? Color(.systemGray5) : Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, 24)
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
}
