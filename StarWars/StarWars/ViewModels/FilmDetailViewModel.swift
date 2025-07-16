//
//  FilmDetailViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import Foundation

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

    func getCharactersFromURL() {
        onCharactersLoading?()

        Task {
            var characters: [Character] = []

            for url in film.characters {
                do {
                    let character = try await characterService.fetchCharacterFromURL(url)
                    characters.append(character)
                } catch {
                    onCharactersError?("Failed to fetch character.")
                }
            }

            onCharactersLoaded?(characters)
        }
    }
}

