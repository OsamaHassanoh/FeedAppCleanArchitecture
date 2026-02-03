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

class NetworkServiceImpl: Network {
    static let shared = NetworkServiceImpl()
    private init() {} // Singleton

    var endpointExecuter: EndpointExecuter = NetworkService()
    var reachability: ReachabilityProtocol = NetworkReachabilityManager.shared // << Use the SwiftUI reachability

    func callModel<Model: Codable>(endpoint: Endpoint) async throws -> Model {
        do {
            let data = try await call(endpoint: endpoint)
            return try JSONDecoder().decode(Model.self, from: data)
        } catch let error as ServerError {
            if error.status == 401 {
                AppState.shared.log("🔁 Token expired. Attempting to refresh token...")
//                try await retryRefreshToken(maxAttempts: 3)
                return try await retryCall(endpoint: endpoint, maxAttempts: 3)
            } else {
                throw error
            }
        } catch {
            throw error
        }
    }

    func call(endpoint: Endpoint) async throws -> Data {
        let maxAttempts = 3
        var attempts = 0
        while attempts < maxAttempts {
            do {
                let response = try await fetchNetworkResponse(endpoint)
                return try processResponse(response)
            } catch let error as ServerError {
                if error.status == 401 {
                    AppState.shared.log("❗️Encountered 401 — skipping retry and escalating to callModel.")
                    throw error
                }
                attempts += 1
                AppState.shared.log("🌐 General call retry (non-401): attempt \(attempts) failed — \(error.localizedDescription)")

                if attempts == maxAttempts {
                    AppState.shared.log("❌ Network call failed after \(maxAttempts) attempts.")
                    throw error
                }
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                attempts += 1
                AppState.shared.log("🌐 General call retry (unknown error): attempt \(attempts) failed — \(error.localizedDescription)")

                if attempts == maxAttempts {
                    AppState.shared.log("❌ Network call failed after \(maxAttempts) attempts.")
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
                AppState.shared.log("🔁 Retry original API after refresh token: attempt \(attempts) failed.")

                if attempts == maxAttempts {
                    AppState.shared.log("❌ Failed after retrying original call \(maxAttempts) times.")
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
            throw (error is ServerError) ? ServerError() : networkFail()
        }
    }

    private func processResponse(_ response: NetworkServiceResponse) throws -> Data {
        do {
            return try networkSuccess(data: response.data, statusCode: response.statusCode)
        } catch {
            throw error
        }
    }

    private func networkSuccess(data: Data, statusCode: Int?) throws -> Data {
        AppState.shared.log("⬆️⬆️ Status Code : \(String(describing: statusCode ?? 0))")
        if (200 ... 299).contains(statusCode ?? 0) {
            return data
        } else {
            guard let error = try? JSONDecoder().decode(ServerError.self, from: data) else {
                throw ServerError(status: statusCode ?? 0)
            }
            throw error
        }
    }

    private func saveHeaders(_: HeaderResponse) {}

    private func networkFail() -> Error {
        return isConnectedToInternet ? FailToCallNetworkError() : NoInternetConnectionError()
    }

    private var isConnectedToInternet: Bool {
        return reachability.isConnected
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
