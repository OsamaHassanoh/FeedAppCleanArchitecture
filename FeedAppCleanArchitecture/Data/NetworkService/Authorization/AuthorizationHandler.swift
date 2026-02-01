//
//  AuthorizationHandler.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

protocol AuthorizationHandler {
    var tokenHeader: [String: String] { get }
    var clientHeader: [String: String] { get }
    func setAuthManually(authToken: String)
    func setUidManually(uid: String)
}
