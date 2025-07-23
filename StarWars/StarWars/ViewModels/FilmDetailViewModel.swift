//
//  FilmDetailViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import Foundation

@MainActor
class FilmDetailViewModel {
    private let film: Film
    private let characterService: CharacterService
    
    init(film: Film, characterService: CharacterService) {
        self.film = film
        self.characterService = characterService
    }
    
    var title: String { film.title }
    var episodeId: String { "\(film.episodeId)" }
    var director: String { film.director }
    var producer: String { film.producer }
    var releaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: film.releaseDate)
    }
    var openingCrawl: String { film.openingCrawl }
    
    var onCharactersLoaded: (([Character]) -> Void)?
    var onCharactersLoading: (() -> Void)?
    var onCharactersError: ((String) -> Void)?
    
    func fetchCharactersFromURL() {
        guard !film.characters.isEmpty else {
            self.onCharactersLoaded?([])
            return
        }
        
        Task {
            onCharactersLoading?()
        }
        
        Task {
            let characters = await fetchCharactersConcurrently(urls: film.characters)
            self.onCharactersLoaded?(characters)
        }
    }
    
    private func fetchCharactersConcurrently(urls: [URL]) async -> [Character] {
        var characters: [Character] = []
        
        await withTaskGroup(of: Character?.self) { group in
            for url in urls {
                group.addTask {
                    try? await self.characterService.fetchCharacterFromURL(url)
                }
            }
            
            for await character in group {
                if let character = character {
                    characters.append(character)
                }
            }
        }
        return characters
    }
}

