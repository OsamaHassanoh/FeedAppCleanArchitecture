//
//  NetworkErrorHandling.swift
//  FeedApplication
//
//  Created by Osama AlMekhlafi on 28/01/2026.
//

import Foundation

struct ServerError: Codable, Error, LocalizedError {
    var error: ErrorValue?
    var message: String? = ""
    var status: Int?
    var rawData: Data?

    init(message: String = "Something went wrong, please try again later", status: Int = 200) {
        self.message = message
        self.status = status
        rawData = nil
    }

    init(status: Int, data: Data?) {
        self.status = status
        rawData = data

        if let data = data {
            // Try to decode error from server response
            if let decoded = try? JSONDecoder().decode(ServerError.self, from: data) {
                error = decoded.error
                message = decoded.message
            } else {
                message = "Something went wrong, please try again later"
            }
        } else {
            message = "No error data from server"
        }
    }

    struct ErrorValue: Codable {
        var errorAsString: String?
        var errorAsList: [String]?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let x = try? container.decode(String.self) {
                errorAsString = x
                return
            } else if let x = try? container.decode([String].self) {
                errorAsList = x
                return
            }

            throw DecodingError.typeMismatch(
                ErrorValue.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for error value")
            )
        }
    }

    var errorDescription: String? {
        if let stringError = error?.errorAsString, !stringError.isEmpty {
            return stringError
        }

        if let list = error?.errorAsList, !list.isEmpty {
            return list[0]
        }

        return message
    }
}

struct FailToCallNetworkError: Error, LocalizedError {
    var errorDescription: String? {
        return "Something went wrong while calling the server. Please try again."
    }
}

struct NoInternetConnectionError: Error, LocalizedError {
    var errorDescription: String? {
        return "No internet connection. Please check your network settings."
    }
}
