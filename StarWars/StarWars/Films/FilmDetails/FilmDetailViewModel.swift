//
//  FilmDetailViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import Foundation

class FilmDetailViewModel {
    let film: Film

    init(film: Film) {
        self.film = film
    }

    var title: String { film.title }
    var episodeId: String { "Episode \(film.episodeId)" }
    var director: String { "Director: \(film.director)" }
    var producer: String { "Producer: \(film.producer)" }
    var releaseDate: String { "Release Date: \(film.releaseDate)" }
    var openingCrawl: String { film.openingCrawl }
}
