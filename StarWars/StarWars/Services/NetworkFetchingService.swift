//
//  NetworkFetchingService.swift
//  StarWars
//
//  Created by Mariana Mendes on 15/07/2025.
//

import Foundation

protocol NetworkFetchingService {
    var urlSession: NetworkSession { get }
    var urlString: String { get }
    var decoder: JSONDecoder { get }
}

extension NetworkFetchingService {
    func fetchData<T: Decodable>(from urlString: String, decodingType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        return try await fetchData(from: url, decodingType: decodingType)
    }

    func fetchData<T: Decodable>(from url: URL, decodingType: T.Type) async throws -> T {
        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
