//
//  FeedDIContainer.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

final class FeedDIContainer {
    private let networkService: Network
    
    init(networkService: Network) {
        self.networkService = networkService
    }
    
    // Feed dependencies only
    private lazy var feedRepository: FeedRepoProtocol = {
        FeedRepository(network: networkService)
    }()
    
    private lazy var fetchFeedsUseCase: FetchFeedsUseCaseProtocol = {
        FetchFeedsUseCase(repository: feedRepository)
    }()
    
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(fetchFeedsUseCase: fetchFeedsUseCase)
    }
}
