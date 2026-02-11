//
//  FeedRepository.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

final class FeedRepository: FeedRepoProtocol, Sendable {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func fetchFeeds() async throws -> [FeedSectionEntity] {
        let dto: FeedResponseDTO = try await network.callModel(
            endpoint: FetchFeedEndPoint()
        )
        return FeedMapper.map(dto)
    }
}
