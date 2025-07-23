//
//  FilmsCoordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import UIKit

@MainActor
final class FilmsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []
    let viewControllerFactory: ViewControllerFactory
    
    init(
        navigationController: UINavigationController,
        viewControllerFactory: ViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let filmsViewController = viewControllerFactory.makeFilmsViewController()
        
        filmsViewController.onFilmSelected = { [weak self] film in
            guard let self else { return }
            let filmDetailViewController = self.viewControllerFactory.makeFilmDetailViewController(for: film)
            
            filmDetailViewController.onCharacterSelected = { [weak self] character in
                guard let self else { return }
                let characterDetailViewController = self.viewControllerFactory.makeCharacterDetailViewController(for: character)
                self.navigationController.pushViewController(characterDetailViewController, animated: true)
            }
            
            self.navigationController.pushViewController(filmDetailViewController, animated: true)
        }
        
        navigationController.pushViewController(filmsViewController, animated: true)
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
