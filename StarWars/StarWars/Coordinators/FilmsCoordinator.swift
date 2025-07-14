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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        let filmDetailViewModel = FilmDetailViewModel(film: film)
        
        let filmDetailViewController = FilmDetailViewController()
        filmDetailViewController.viewModel = filmDetailViewModel
        
        navigationController.pushViewController(filmDetailViewController, animated: true)
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
