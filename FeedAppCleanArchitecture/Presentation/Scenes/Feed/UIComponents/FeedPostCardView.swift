//
//  FeedPostCardView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI
import Kingfisher

struct FeedPostCardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let postEntity: PostEntity
    
    var body: some View {
        NavigationLink(destination: PostDetailView(postEntity: postEntity)) {
            cardContent
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User header with cached profile image
            HStack(spacing: 12) {
                KFImage(postEntity.user.profileImageURL)
                    .placeholder {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .tint(.white)
                            )
                    }
                    .retry(maxCount: 3, interval: .seconds(2))
                    .fade(duration: 0.3)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(postEntity.user.username)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .foregroundColor(.primary)
            }
            
            // Post image with caching (tappable)
            KFImage(postEntity.imageURL)
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        )
                }
                .retry(maxCount: 3, interval: .seconds(2))
                .fade(duration: 0.3)
                .resizable()
                .scaledToFill()
                .frame(height: 320)
                .clipped()
                .cornerRadius(16)
            
            // Action buttons (non-interactive in card)
            HStack(spacing: 16) {
                Image(systemName: postEntity.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(postEntity.isLiked ? themeManager.selectedTheme.colors.likedBg : themeManager.selectedTheme.colors.bodyTextColor)
                Image(systemName: "bubble.right")
                    .foregroundColor(.primary)
                Spacer()
            }
            .font(.title3)

            // Post details
            VStack(alignment: .leading, spacing: 4) {
                Text("\(postEntity.likesCount) likes")
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)

                Text(postEntity.caption)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        )
        .padding(.horizontal)
    }
}
