//
//  FeedDIContainer.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//
@MainActor
final class FeedDIContainer {
    private let networkService: Network
    private let router: AppRouter

    init(networkService: Network, router: AppRouter) {
        self.networkService = networkService
        self.router = router
    }

    private lazy var feedRepository: FeedRepoProtocol = {
        FeedRepository(network: networkService)
    }()

    private lazy var fetchFeedsUseCase: FetchFeedsUseCaseProtocol = {
        FetchFeedsUseCase(repository: feedRepository)
    }()

    // MARK: - ViewModels

    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(
            fetchFeedsUseCase: fetchFeedsUseCase,
            router: router
        )
    }
}
