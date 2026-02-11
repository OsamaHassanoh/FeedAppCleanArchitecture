//
//  FetchFeedEndPoint.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

struct FetchFeedEndPoint: Endpoint {
    var urlPrefix: String = ""
    var service: EndpointService = .getFeed
    var method: EndpointMethod = .get
    var encoding: EndpointEncoding = .json
    var auth: AuthorizationHandler = NoAuthHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [
        "User-Agent": "iOS-App"
    ]
}
