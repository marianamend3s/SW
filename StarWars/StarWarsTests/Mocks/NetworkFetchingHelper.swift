//
//  NetworkFetchingHelper.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import Foundation
@testable import StarWars

final class NetworkFetchingHelper: NetworkFetchingService {
    let urlSession: NetworkSession
    let urlString: String
    let decoder: JSONDecoder

    init(urlSession: NetworkSession, urlString: String, decoder: JSONDecoder) {
        self.urlSession = urlSession
        self.urlString = urlString
        self.decoder = decoder
    }
}

struct DummyModel: Codable, Equatable {
    let name: String
}
