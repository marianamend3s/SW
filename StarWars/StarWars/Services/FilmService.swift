//
//  FilmService.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

protocol FilmService {
    func fetchFilms() async throws -> [Film]
}

class FilmServiceImpl: NetworkService, FilmService {
    let urlSession: URLSession
    let urlString: String
    let decoder: JSONDecoder

    init(
        urlSession: URLSession = .shared,
        urlString: String = "https://swapi.info/api/films/",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.urlString = urlString
        self.decoder = decoder
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchFilms() async throws -> [Film] {
        do {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await self.urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            return try decoder.decode([Film].self, from: data)
            
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
