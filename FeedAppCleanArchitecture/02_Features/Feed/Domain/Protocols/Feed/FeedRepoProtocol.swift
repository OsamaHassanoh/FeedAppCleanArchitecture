//
//  FeedRepoProtocol.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

protocol FeedRepoProtocol: Sendable {
    func fetchFeeds() async throws -> [FeedSectionEntity]
}
