//
//  NoAuthHandler.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

class NoAuthHandler: AuthorizationHandler {
    func setAuthManually(authToken _: String) {}

    func setUidManually(uid _: String) {}

    var tokenHeader: [String: String] {
        [:]
    }

    var clientHeader: [String: String] {
        [:]
    }
}
