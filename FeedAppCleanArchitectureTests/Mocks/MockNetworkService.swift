//
//  MockNetworkService.swift
//  FeedAppCleanArchitectureTests
//
//  Created by Osama AlMekhlafi on 02/02/2026.
//

import Foundation
@testable import FeedAppCleanArchitecture

final class MockNetworkService: Network {
    var shouldReturnError = false
    var mockResponse: Any?
    var callModelCallCount = 0
    
    func callModel<Model: Codable>(endpoint: Endpoint) async throws -> Model {
        callModelCallCount += 1
        
        if shouldReturnError {
            throw ServerError(message: "Mock network error", status: 500)
        }
        
        guard let response = mockResponse as? Model else {
            throw NSError(domain: "MockError", code: -1)
        }
        
        return response
    }
}
