//
//  MockFilmService.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

class MockFilmService: FilmService {
    var result: Result<[Film], Error>!

    func fetchFilms() async throws -> [Film] {
        switch result {
        case .success(let films):
            return films
        case .failure(let error):
            throw error
        case .none:
            fatalError("Fatal error")
        }
    }
}
