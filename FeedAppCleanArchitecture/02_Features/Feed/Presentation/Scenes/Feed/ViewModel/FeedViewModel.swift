//
//  FeedViewModel.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {

    @Published var state: ViewState = .loading
    @Published var selectedSectionIndex: Int = 0

    private let fetchFeedsUseCase: FetchFeedsUseCaseProtocol
    private let router: AppRouter
    private var cancellables = Set<AnyCancellable>()

    enum ViewState: Equatable {
        case loading
        case loaded([FeedSectionEntity])
        case error(String)
        
        static func == (lhs: ViewState, rhs: ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.loaded(let lhsFeeds), .loaded(let rhsFeeds)):
                return lhsFeeds.map(\.id) == rhsFeeds.map(\.id)
            case (.error(let lhsMsg), .error(let rhsMsg)):
                return lhsMsg == rhsMsg
            default:
                return false
            }
        }
    }
    
    var feeds: [FeedSectionEntity] {
        if case .loaded(let feeds) = state {
            return feeds
        }
        return []
    }
    
    var selectedSection: FeedSectionEntity? {
        guard !feeds.isEmpty, selectedSectionIndex < feeds.count else {
            return nil
        }
        return feeds[selectedSectionIndex]
    }
    
    init(
        fetchFeedsUseCase: FetchFeedsUseCaseProtocol,
        router: AppRouter
    ) {
        self.fetchFeedsUseCase = fetchFeedsUseCase
        self.router = router
    }
    
    // MARK: - Data Loading
    
    func loadFeeds() async {
        state = .loading
        
        do {
            let feeds = try await fetchFeedsUseCase.execute()
            state = feeds.isEmpty ? .error("No feeds available") : .loaded(feeds)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func refreshFeeds() async {
        do {
            let feeds = try await fetchFeedsUseCase.execute()
            state = feeds.isEmpty ? .error("No feeds available") : .loaded(feeds)
        } catch {
            if case .loaded = state {
                // Keep existing data
            } else {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func selectSection(at index: Int) {
        guard index >= 0, index < feeds.count else { return }
        selectedSectionIndex = index
    }
    
    // MARK: - Navigation

    func navigateToPostDetail(_ post: PostEntity) {
        router.push(.postDetail(post: post))
    }
    
    func navigateToUserProfile(_ user: UserEntity) {
        router.push(.userProfile(user: user))
    }
    
    func navigateToImageViewer(imageURL: URL, heroTag: String) {
        router.presentFullScreen(.imageViewer(imageURL: imageURL, heroTag: heroTag))
    }
    
    func navigateToSettings() {
        router.push(.settings)
    }
    
    func navigateToSearch() {
        router.push(.search)
    }
}
