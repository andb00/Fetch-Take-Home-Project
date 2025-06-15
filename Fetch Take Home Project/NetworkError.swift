//
//  NetworkError.swift
//  Fetch Take Home Project
//
//  Created by Andrew Betancourt on 6/13/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case noData
    case decodingFailed
    case urlSessionError(Error)
    case invalidURL(String)
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data returned from the server."
        case .decodingFailed:
            return "Failed to decode data into a Swift object."
        case .urlSessionError(let underlyingError):
            return "URL Session error: \(underlyingError.localizedDescription)"
        case .invalidURL(let urlString):
            return "This URL is not valid: \(urlString)"
        }
    }
}
