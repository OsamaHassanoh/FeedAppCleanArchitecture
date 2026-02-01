//
//  NetworkService.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

class NetworkService: EndpointExecuter {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }()

    func execute(_ endpoint: Endpoint) async throws -> NetworkServiceResponse {
        let request = try await self.request(by: endpoint)

        return try await withCheckedThrowingContinuation { continuation in
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: RequestError.invalidResponse)
                    return
                }

                let statusCode = httpResponse.statusCode
                let headers = httpResponse.allHeaderFields
                let responseData = data ?? Data()

                // Handle success manually
                if (200 ... 299).contains(statusCode) {
                    let networkResponse = NetworkServiceResponse(
                        data: responseData,
                        statusCode: statusCode,
                        headers: headers
                    )
                    continuation.resume(returning: networkResponse)
                } else {
                    // Throw custom ServerError with status and raw data
                    continuation.resume(throwing: ServerError(status: statusCode, data: responseData))
                }
            }

            dataTask.resume()
        }
    }

    private func request(by endpoint: Endpoint) async throws -> URLRequest {
        AppState.shared.log("ℹ️ Endpoint URL : \(endpoint.service.baseUrl + endpoint.service.url + endpoint.urlPrefix)")
        AppState.shared.log("ℹ️ Method : \(endpoint.method.rawValue)")
        AppState.shared.log("ℹ️ Parameters : \(endpoint.parameters)")
        AppState.shared.log("ℹ️ Headers : \(endpoint.headers)")

        let fullUrlString = endpoint.service.baseUrl + endpoint.service.url + endpoint.urlPrefix
        var urlComponents = URLComponents(string: fullUrlString)

        // For GET requests (or if encoding == .query), add parameters to URL
        if endpoint.method == .get || endpoint.encoding == .query {
            if !endpoint.parameters.isEmpty {
                urlComponents?.queryItems = endpoint.parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
            }
        }

        guard let url = urlComponents?.url else {
            fatalError("Invalid URL: \(fullUrlString)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue.uppercased()
        request.allHTTPHeaderFields = concatenateHeaders(for: endpoint)

        // For POST, PUT, PATCH methods, handle parameters as body
        if endpoint.method == .post || endpoint.method == .put || endpoint.method == .patch {
            if endpoint.encoding == .json {
                // JSON body
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if !endpoint.parameters.isEmpty {
                    request.httpBody = try JSONSerialization.data(withJSONObject: endpoint.parameters, options: [])
                }
            } else if endpoint.encoding == .customFormURLEncoded {
                // Form URL Encoded body
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let bodyString = endpoint.parameters.map { key, value in
                    "\(key)=\(String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                }.joined(separator: "&")
                request.httpBody = bodyString.data(using: .utf8)
            }
        }

        return request
    }

    private func concatenateHeaders(for endpoint: Endpoint) -> [String: String] {
        var headers = endpoint.headers.filter { !$0.value.isEmpty }

        for (key, value) in endpoint.auth.tokenHeader {
            headers[key] = value
        }
        for (key, value) in endpoint.auth.clientHeader {
            headers[key] = value
        }

        return headers
    }
}

extension EndpointMethod {
    var urlMethod: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .put: return "PUT"
        case .patch: return "PATCH"
        }
    }
}

enum RequestError: Error {
    case invalidParameter(String)
    case invalidResponse
}
