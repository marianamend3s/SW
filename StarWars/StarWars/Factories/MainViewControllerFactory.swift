//
//  MainViewControllerFactory.swift
//  StarWars
//
//  Created by Mariana Mendes on 23/07/2025.
//

import UIKit

final class MainViewControllerFactory: ViewControllerFactory {
    func makeCategoriesViewController() -> CategoriesViewController {
        let service = CategoryServiceImpl()
        let viewModel = CategoriesViewModel(categoryService: service)
        let viewController = CategoriesViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeFilmsViewController() -> FilmsViewController {
        let service = FilmServiceImpl()
        let viewModel = FilmsViewModel(filmsService: service)
        let viewController = FilmsViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeFilmDetailViewController(for film: Film) -> FilmDetailViewController {
        let service = CharacterServiceImpl()
        let viewModel = FilmDetailViewModel(film: film, characterService: service)
        let viewController = FilmDetailViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCharactersViewController() -> CharactersViewController {
        let service = CharacterServiceImpl()
        let viewModel = CharacterViewModel(characterService: service)
        let viewController = CharactersViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCharacterDetailViewController(for character: Character) -> CharacterDetailViewController {
        let viewModel = CharacterDetailViewModel(character: character)
        let viewController = CharacterDetailViewController(viewModel: viewModel)
        return viewController
    }
}
