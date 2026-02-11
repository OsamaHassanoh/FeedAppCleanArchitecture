//
//  FetchFeedsUseCase.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

final class FetchFeedsUseCase: FetchFeedsUseCaseProtocol, Sendable {
    private let repository: FeedRepoProtocol

    init(repository: FeedRepoProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [FeedSectionEntity] {
        try await repository.fetchFeeds()
    }
}
