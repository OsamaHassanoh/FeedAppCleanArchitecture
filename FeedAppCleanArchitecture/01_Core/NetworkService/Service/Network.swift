//
//  Network.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

protocol Network: Sendable {
    func callModel<Model: Codable>(endpoint: Endpoint) async throws -> Model
}
