//
//  NetworkServiceImpl.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation
import Network
import SwiftUI

protocol EndpointExecuter {
    func execute(_ endpoint: Endpoint) async throws -> NetworkServiceResponse
}

protocol ReachabilityProtocol {
    var isConnected: Bool { get }
}

final class NetworkServiceImpl: Network, @unchecked Sendable {
    static let shared = NetworkServiceImpl()
    private init() {}

    var endpointExecuter: EndpointExecuter = NetworkService()
    var reachability: ReachabilityProtocol = NetworkReachabilityManager.shared

    func callModel<Model: Codable>(endpoint: Endpoint) async throws -> Model {
        do {
            let data = try await call(endpoint: endpoint)
            return try JSONDecoder().decode(Model.self, from: data)
        } catch let error as ServerError where error.status == 401 {
            AppState.shared.log("[Network] Token expired. Attempting retry...")
            return try await retryCall(endpoint: endpoint, maxAttempts: 3)
        }
    }

    func call(endpoint: Endpoint) async throws -> Data {
        let maxAttempts = 3
        var attempts = 0
        while attempts < maxAttempts {
            do {
                let response = try await fetchNetworkResponse(endpoint)
                return try processResponse(response)
            } catch let error as ServerError where error.status == 401 {
                throw error
            } catch {
                attempts += 1
                AppState.shared.log("[Network] Retry attempt \(attempts) failed: \(error.localizedDescription)")

                if attempts == maxAttempts {
                    AppState.shared.log("[Network] Failed after \(maxAttempts) attempts.")
                    throw error
                }
                try await Task.sleep(nanoseconds: 500_000_000)
            }
        }
        throw FailToCallNetworkError()
    }

    private func retryCall<Model: Codable>(endpoint: Endpoint, maxAttempts: Int) async throws -> Model {
        var attempts = 0
        while attempts < maxAttempts {
            do {
                let data = try await call(endpoint: endpoint)
                return try JSONDecoder().decode(Model.self, from: data)
            } catch {
                attempts += 1
                AppState.shared.log("[Network] Retry after token refresh: attempt \(attempts) failed.")

                if attempts == maxAttempts {
                    throw error
                }
                try await Task.sleep(nanoseconds: 500_000_000)
            }
        }
        throw FailToCallNetworkError()
    }

    private func fetchNetworkResponse(_ endpoint: Endpoint) async throws -> NetworkServiceResponse {
        do {
            return try await endpointExecuter.execute(endpoint)
        } catch let error as ServerError {
            throw error
        } catch {
            throw networkFail()
        }
    }

    private func processResponse(_ response: NetworkServiceResponse) throws -> Data {
        try networkSuccess(data: response.data, statusCode: response.statusCode)
    }

    private func networkSuccess(data: Data, statusCode: Int?) throws -> Data {
        AppState.shared.log("[Network] Status Code: \(statusCode ?? 0)")
        if (200...299).contains(statusCode ?? 0) {
            return data
        } else {
            throw ServerError(status: statusCode ?? 0, data: data)
        }
    }

    private func networkFail() -> Error {
        isConnectedToInternet ? FailToCallNetworkError() : NoInternetConnectionError()
    }

    private var isConnectedToInternet: Bool {
        reachability.isConnected
    }
}

struct NetworkServiceResponse {
    var data: Data
    var statusCode: Int?
    var headers: [AnyHashable: Any]?
}

struct HeaderResponse: Codable {
    var token: String?
    var client: String?
    var uid: String?

    enum CodingKeys: String, CodingKey {
        case token = "access-token"
        case client, uid
    }
}
