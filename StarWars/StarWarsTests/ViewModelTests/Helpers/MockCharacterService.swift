//
//  MockCharacterService.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

class MockCharacterService: CharacterService {
    var fetchCharactersResult: Result<[Character], Error>!
    var fetchCharacterFromURLResult: Result<Character, Error>!
    var receivedFetchCharacterFromURL: URL?
    
    func fetchCharacters() async throws -> [Character] {
        switch fetchCharactersResult {
        case .success(let characters):
            return characters
        case .failure(let error):
            throw error
        case .none:
            fatalError("Fatal error")
        }
    }
    
    func fetchCharacterFromURL(_ url: URL) async throws -> Character {
        receivedFetchCharacterFromURL = url
        
        switch fetchCharacterFromURLResult {
        case .success(let character):
            return character
        case .failure(let error):
            throw error
        case .none:
            fatalError("Fatal error")
        }
    }
}
