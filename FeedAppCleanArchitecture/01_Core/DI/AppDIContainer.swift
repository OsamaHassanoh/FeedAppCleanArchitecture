//
//  DIContainer.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 31/01/2026.
//

import Foundation

@MainActor
final class AppDIContainer {
    static let shared = AppDIContainer()

    // MARK: - Core Dependencies

    private lazy var networkService: Network = {
        NetworkServiceImpl.shared
    }()

    private(set) lazy var router: AppRouter = {
        AppRouter()
    }()

    // MARK: - Feature Containers

    lazy var feedContainer: FeedDIContainer = {
        FeedDIContainer(networkService: networkService, router: router)
    }()

    private init() {}
}
