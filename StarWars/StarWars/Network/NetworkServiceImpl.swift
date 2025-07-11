//
//  NetworkServiceImpl.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

class NetworkServiceImpl: NetworkService {
    
    // TODO: - Put this elsewhere
    let filmsUrlString = "https://swapi.info/api/films/"
    
    func getFilms() async throws -> [Film] {
        guard let url = URL(string: filmsUrlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Film].self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
