//
//  FetchFeedsUseCaseProtocol.swift
//  FeedAppCleanArchitecture
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import Foundation

protocol FetchFeedsUseCaseProtocol: Sendable {
    func execute() async throws -> [FeedSectionEntity]
}
