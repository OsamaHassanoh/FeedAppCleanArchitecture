//
//  DIContainer.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 31/01/2026.
//

final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Network Layer
    private lazy var networkService: Network = {
        NetworkServiceImpl.shared
    }()
    
    // MARK: - Repositories
    private lazy var feedRepository: FeedRepoProtocol = {
        FeedRepository(network: networkService)
    }()
    
    // MARK: - Use Cases
    func makeFetchFeedsUseCase() -> FetchFeedsUseCaseProtocol {
        FetchFeedsUseCase(repository: feedRepository)
    }
    
    // MARK: - ViewModels
    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(fetchFeedsUseCase: makeFetchFeedsUseCase())
    }
}
