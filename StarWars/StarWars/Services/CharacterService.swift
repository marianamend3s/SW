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

class CharacterServiceImpl: NetworkFetchingService, CharacterService {
    let urlSession: NetworkSession
    let urlString: String
    let decoder: JSONDecoder
    
    init(
        urlSession: NetworkSession = URLSession.shared,
        urlString: String = "https://swapi.info/api/people/",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.urlString = urlString
        self.decoder = decoder
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func fetchCharacters() async throws -> [Character] {
        return try await fetchData(from: urlString, decodingType: [Character].self)
    }

    func fetchCharacterFromURL(_ url: URL) async throws -> Character {
        return try await fetchData(from: url, decodingType: Character.self)
    }

}
