//
//  AppState.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Combine
import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    private init() {} // Private init to ensure it’s a singleton
    func log(_ message: String) {
        #if DEBUG
            print(message)
        #endif
    }
}
