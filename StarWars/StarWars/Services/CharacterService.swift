//
//  CharacterService.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

protocol CharacterService {
    func fetchCharacters() async throws -> [Character]
    func fetchCharacterFromURL(_ url: URL) async throws -> Character
}

class CharacterServiceImpl: NetworkService, CharacterService {
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
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchCharacters() async throws -> [Character] {
        do {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await self.urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            return try decoder.decode([Character].self, from: data)
            
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchCharacterFromURL(_ url: URL) async throws -> Character {
        do {
            let (data, response) = try await self.urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            return try decoder.decode(Character.self, from: data)
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
