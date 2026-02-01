//
//  FeedView.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//
import SwiftUI
import Combine

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    @State private var selectedSectionID: String = ""
    
    // ✅ Dependency Injection
    init(viewModel: FeedViewModel = DIContainer.shared.makeFeedViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    LoadingView()
                case .error:
                    ErrorView(
                        message: viewModel.errorMessage ?? "Something went wrong",
                        retry: { Task { await viewModel.loadFeeds() } }
                    )
                case .loaded:
                    content
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            if viewModel.feeds.isEmpty {
                await viewModel.loadFeeds()
            }
        }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            FeedSectionSelectorView(
                feedSectionEntity: viewModel.feeds,
                selectedSectionID: selectedSectionID
            ) { id in
                selectedSectionID = id
            }
            
            Divider()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(currentPosts) { post in
                        FeedPostCardView(postEntity: post)
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            if selectedSectionID.isEmpty {
                selectedSectionID = viewModel.feeds.first?.id ?? ""
            }
        }
    }
    private var currentPosts: [PostEntity] {
        viewModel.feeds.first(where: { $0.id == selectedSectionID })?.posts ?? []
    }
}
