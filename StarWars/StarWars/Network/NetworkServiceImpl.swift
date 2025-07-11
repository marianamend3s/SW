//
//  NetworkServiceImpl.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

class NetworkServiceImpl: NetworkService {
    private let urlSession: URLSession
    private let filmsURLString: String
    
    init(urlSession: URLSession = .shared, filmsURLString: String = "https://swapi.info/api/films/") {
        self.urlSession = urlSession
        self.filmsURLString = filmsURLString
    }
    
    func getFilms() async throws -> [Film] {
        do {
            guard let url = URL(string: filmsURLString) else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await self.urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode([Film].self, from: data)
            
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
