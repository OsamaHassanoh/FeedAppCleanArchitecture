//
//  NetworkReachabilityManager.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Combine
import Network
import SwiftUI

class NetworkReachabilityManager: ObservableObject, ReachabilityProtocol {
    static let shared = NetworkReachabilityManager()

    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkReachabilityMonitor")

    @Published var isReachable: Bool = true

    var isConnected: Bool {
        return isReachable
    }

    private init() {
        setupReachability()
    }

    func setupReachability() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isReachable = path.status == .satisfied
            }
        }
        monitor?.start(queue: queue)
    }

    func stopListening() {
        monitor?.cancel()
        monitor = nil
    }
}
