//
//  PostDetailView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    let postEntity: PostEntity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Large post image
                KFImage(postEntity.imageURL)
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(ProgressView())
                    }
                    .retry(maxCount: 3, interval: .seconds(2))
                    .fade(duration: 0.3)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(0)
                
                // Post information
                VStack(alignment: .leading, spacing: 16) {
                    // User header
                    HStack(spacing: 12) {
                        KFImage(postEntity.user.profileImageURL)
                            .placeholder {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(ProgressView().tint(.white))
                            }
                            .retry(maxCount: 3)
                            .fade(duration: 0.3)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(postEntity.user.username)
                                .font(.headline)
                            
                            Text(formatDate(postEntity.createdAt))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Divider()
                    
                    // Action buttons
                    HStack(spacing: 24) {
                        HStack(spacing: 8) {
                            Image(systemName: postEntity.isLiked ? "heart.fill" : "heart")
                                .foregroundColor(postEntity.isLiked ? themeManager.selectedTheme.colors.likedBg : .primary)
                            Text("\(postEntity.likesCount)")
                                .font(.subheadline)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "bubble.right")
                            Text("\(postEntity.commentsCount)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    .font(.title3)
                    
                    Divider()
                    
                    // Caption
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption")
                            .font(.headline)
                        
                        Text(postEntity.caption)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
