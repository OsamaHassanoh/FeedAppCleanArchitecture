//
//  Endpoint.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//
import Foundation

protocol Endpoint {
    var service: EndpointService { get set }
    var urlPrefix: String { get set }
    var method: EndpointMethod { get set }
    var auth: AuthorizationHandler { get set }
    var parameters: [String: Any] { get set }
    var encoding: EndpointEncoding { get set }
    var headers: [String: String] { get set }
}

enum EndpointEncoding {
    case json
    case query
    case customFormURLEncoded
}

enum EndpointMethod: String {
    case get
    case post
    case put
    case delete
    case patch
}

enum EndpointService {
    case getUserInfo
    case getFeed

    var url: String {
        switch self {
        case .getUserInfo:
            return "getUserInfo"
        case .getFeed:
            return "feed.json"
        }
    }
}

extension EndpointService {
    var baseUrl: String {
        switch self {
        default:
            return "https://raw.githubusercontent.com/SreelekhN/jazi-ios-machine-test-api/main/"
        }
    }
}
