//
//  FetchFeedsUseCase.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import SwiftUI

protocol FetchFeedsUseCaseProtocol {
    func fetchFeeds() async throws -> [FeedSectionEntity]
}

final class FetchFeedsUseCase: FetchFeedsUseCaseProtocol {
    private let repository: FeedRepoProtocol
    init(repository: FeedRepoProtocol) {
        self.repository = repository
    }

    func fetchFeeds() async throws -> [FeedSectionEntity] {
        return try await repository.fetchFeeds()
    }
}
