//
//  UserAuthoriationHandlerImpl.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

class UserAuthoriationHandler: AuthorizationHandler {
    private let keychainTokenKey = "keychainTokenKey"
    private let uidKey = "uidAuthoriztionHeader"

    init() {}

    var clientHeader: [String: String] {
        return [:]
    }

    var uidHeader: [String: String] {
        return ["iOS-App": "User-Agent"]
    }

    var tokenHeader: [String: String] {
        AppState.shared.log("ℹ️ Token : \(getAuthManually()!)")
        return ["Authorization": "Bearer " + getAuthManually()!]
    }

    func setAuthManually(authToken _: String) {}

    ///
    func getAuthManually() -> String? {
        return ""
    }

    func setUidManually(uid _: String) {}
}
