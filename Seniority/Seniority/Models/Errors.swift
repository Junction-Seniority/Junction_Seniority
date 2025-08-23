//
//  Errors.swift
//  Seniority
//
//  Created by bishoe01 on 8/23/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case decodingFailed(Error)
    case encodingFailed(Error)
    case networkError(Error)
    case httpError(Int)
    case noContent
    case noChoices
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .noData:
            return "No data received from server"
        case .invalidResponse:
            return "Invalid response format"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode)"
        case .noContent:
            return "No content in response"
        case .noChoices:
            return "No choices in response"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}

enum UIError: Error, LocalizedError {
    case invalidInput
    case emptyMessage
    case loadingState

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Please enter a valid message"
        case .emptyMessage:
            return "Message cannot be empty"
        case .loadingState:
            return "Please wait for current request to complete"
        }
    }
}

enum ValidationError: Error, LocalizedError {
    case messageTooShort
    case messageTooLong
    case invalidCharacters

    var errorDescription: String? {
        switch self {
        case .messageTooShort:
            return "Message is too short"
        case .messageTooLong:
            return "Message is too long"
        case .invalidCharacters:
            return "Message contains invalid characters"
        }
    }
}
