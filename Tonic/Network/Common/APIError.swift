//
//  APIError.swift
//  Tonic
//

import Foundation

/// List of errors for the cocktail services.
enum APIError: LocalizedError {
    case invalidURL
    case serviceError
    case decodeError
    case unknown
    case error(Error)
}
