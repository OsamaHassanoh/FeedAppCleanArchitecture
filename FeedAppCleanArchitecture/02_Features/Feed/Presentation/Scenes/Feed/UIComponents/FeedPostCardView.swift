//
//  FeedPostCardView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI
import Kingfisher

struct FeedPostCard: View {
    let post: PostEntity
    let onPostTap: () -> Void
    let onUserTap: () -> Void
    let onImageTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            userHeader
            postImage
            actionsRow
            caption
            timestamp
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    // MARK: - User Header
    
    private var userHeader: some View {
        HStack(spacing: 10) {
            // User avatar and name
            HStack(spacing: 10) {
                KFImage(post.user.profileImageURL)
                    .placeholder { SkeletonCircle(size: 40) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(post.user.username)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onUserTap()
            }
            
            Spacer()
            
            Image(systemName: "ellipsis")
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Post Image
    
    private var postImage: some View {
        KFImage(post.imageURL)
            .placeholder {
                SkeletonRect(
                    height: UIScreen.main.bounds.width - 32,
                    cornerRadius: 0
                )
            }
            .resizable()
            .scaledToFill()
            .aspectRatio(1, contentMode: .fill)
            .clipped()
            .contentShape(Rectangle())
            .onTapGesture {
                onImageTap()
            }
    }
    
    // MARK: - Actions Row
    
    private var actionsRow: some View {
        HStack(spacing: 16) {
            // Like (not interactive for now)
            HStack(spacing: 4) {
                Image(systemName: post.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(post.isLiked ? .red : .primary)
                Text("\(post.likesCount)")
                    .font(.system(size: 14, weight: .medium))
            }
            
            // Comment - navigates to post
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                Text("\(post.commentsCount)")
                    .font(.system(size: 14, weight: .medium))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onPostTap()
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    // MARK: - Caption
    
    private var caption: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(post.user.username)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
            +
            Text(" ")
            +
            Text(post.caption)
                .font(.system(size: 14))
                .foregroundColor(.primary)
        }
        .lineLimit(2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            onPostTap()
        }
    }
    
    // MARK: - Timestamp
    
    private var timestamp: some View {
        Text(timeAgo(from: post.createdAt))
            .font(.system(size: 12))
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
    
    private func timeAgo(from date: Date) -> String {
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date,
            to: Date()
        )
        
        if let years = components.year, years > 0 {
            return "\(years)y"
        } else if let months = components.month, months > 0 {
            return "\(months)mo"
        } else if let days = components.day, days > 0 {
            return "\(days)d"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m"
        }
        return "now"
    }
}
