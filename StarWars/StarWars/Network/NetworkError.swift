//
//  NetworkError.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL for fetching data was invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}
