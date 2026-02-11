//
//  FeedView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//
import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                FeedSkeletonView()

            case .loaded:
                feedContent

            case .error(let message):
                ErrorView(
                    message: message,
                    retry: { Task { await viewModel.loadFeeds() } }
                )
            }
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            toolbarContent
        }
        .task {
            await viewModel.loadFeeds()
        }
    }
    
    // MARK: - Feed Content
    
    private var feedContent: some View {
        VStack(spacing: 0) {
            FeedSectionSelector(
                sections: viewModel.feeds,
                selectedIndex: viewModel.selectedSectionIndex,
                onSectionSelected: { index in
                    viewModel.selectSection(at: index)
                }
            )
            
            Divider()
            
            postsList
        }
    }
    
    private var postsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if let section = viewModel.selectedSection {
                    ForEach(section.posts, id: \.id) { post in
                        FeedPostCard(
                            post: post,
                            onPostTap: { viewModel.navigateToPostDetail(post) },
                            onUserTap: { viewModel.navigateToUserProfile(post.user) },
                            onImageTap: {
                                viewModel.navigateToImageViewer(
                                    imageURL: post.imageURL,
                                    heroTag: "post_\(post.id)"
                                )
                            }
                        )
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .refreshable {
            await viewModel.refreshFeeds()
        }
    }

    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    viewModel.navigateToSearch()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                Button {
                    viewModel.navigateToSettings()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}
