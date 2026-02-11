//
//  RouterView.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 08/02/2026.
//
import SwiftUI

struct RouterView: View {
    let route: AppRoute
    
    var body: some View {
        buildView(for: route)
    }
    
    @ViewBuilder
    private func buildView(for route: AppRoute) -> some View {
        switch route {
        case .feed:
            FeedView(viewModel: AppDIContainer.shared.feedContainer.makeFeedViewModel())
        case .postDetail(let post):
            PostDetailView(post: post)
        case .userProfile(let user):
            UserProfileView(user: user)
        case .imageViewer(let imageURL, let heroTag):
            ImageViewerView(imageURL: imageURL, heroTag: heroTag)
        case .settings:
            SettingsView()
        case .search:
            SearchView()
        }
    }
}
