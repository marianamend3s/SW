//
//  ViewControllerFactory.swift
//  StarWars
//
//  Created by Mariana Mendes on 23/07/2025.
//

import Foundation

protocol ViewControllerFactory {
    func makeCategoriesViewController() -> CategoriesViewController
    func makeFilmsViewController() -> FilmsViewController
    func makeFilmDetailViewController(for film: Film) -> FilmDetailViewController
    func makeCharactersViewController() -> CharactersViewController
    func makeCharacterDetailViewController(for character: Character) -> CharacterDetailViewController
}
