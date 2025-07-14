//
//  FilmDetailViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

class FilmDetailViewModel {
    private let film: Film
    private let characterService: CharacterService

    init(film: Film, characterService: CharacterService) {
        self.film = film
        self.characterService = characterService
    }

    var title: String { film.title }
    var episodeId: String { "Episode \(film.episodeId)" }
    var director: String { "Director: \(film.director)" }
    var producer: String { "Producer: \(film.producer)" }
    var releaseDate: String { "Release Date: \(film.releaseDate)" }
    var openingCrawl: String { film.openingCrawl }

    var onCharactersLoaded: (([Character]) -> Void)?
    var onCharactersError: ((String) -> Void)?

    func getCharactersFromURL() {
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

