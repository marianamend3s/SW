//
//  FilmsCoordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import UIKit

class FilmsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []
    var characterService: CharacterService

    init(navigationController: UINavigationController, characterService: CharacterService = CharacterServiceImpl()) {
        self.navigationController = navigationController
        self.characterService = characterService
    }

    func start() {
        let filmsService = FilmServiceImpl()
        let filmsViewModel = FilmsViewModel(filmsService: filmsService)
        let filmsViewController = FilmsViewController()
        filmsViewController.viewModel = filmsViewModel
        
        filmsViewController.onFilmSelected = { [weak self] film in
            self?.navigateToFilmDetails(film: film)
        }
        navigationController.pushViewController(filmsViewController, animated: true)
    }
    
    func navigateToFilmDetails(film: Film) {
        let filmDetailViewModel = FilmDetailViewModel(film: film, characterService: characterService)
        
        let filmDetailViewController = FilmDetailViewController()
        filmDetailViewController.viewModel = filmDetailViewModel
        
        onFilmCharacterSelected(filmDetailViewController: filmDetailViewController)
        
        navigationController.pushViewController(filmDetailViewController, animated: true)
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
    
    private func onFilmCharacterSelected(filmDetailViewController: FilmDetailViewController) {
        filmDetailViewController.onCharacterSelected = { [weak self] character in
            let characterDetailViewModel = CharacterDetailViewModel(character: character)
            let characterDetailViewController = CharacterDetailViewController()
            characterDetailViewController.viewModel = characterDetailViewModel
            self?.navigationController.pushViewController(characterDetailViewController, animated: true)
        }
    }
}
