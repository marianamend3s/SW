//
//  MockNetworkSession.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation
@testable import StarWars

class MockNetworkSession: NetworkSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        guard let data = mockData, let response = mockResponse else {
            throw URLError(.badServerResponse)
        }

        return (data, response)
    }
}
