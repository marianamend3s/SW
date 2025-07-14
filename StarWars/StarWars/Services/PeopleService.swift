//
//  PeopleService.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

protocol PeopleService {
    func getPeople() async throws -> [People]
}

class PeopleServiceImpl: NetworkService, PeopleService {
    let urlSession: URLSession
    let urlString: String
    let decoder: JSONDecoder

    init(
        urlSession: URLSession = .shared,
        urlString: String = "https://swapi.info/api/people/",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.urlString = urlString
        self.decoder = decoder
    }
    
    func getPeople() async throws -> [People] {
        do {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await self.urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            return try decoder.decode([People].self, from: data)
            
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
