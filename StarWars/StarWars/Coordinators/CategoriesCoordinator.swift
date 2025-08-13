//
//  CategoriesCoordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

final class CategoriesCoordinator: Coordinator {
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
        let categoriesViewController = viewControllerFactory.makeCategoriesViewController()
        
        categoriesViewController.onCategorySelected = { [weak self] category in
            switch category {
            case "films": self?.onFilmsSelected()
            case "people": self?.onCharactersSelected()
            default: break
            }
        }
        
        navigationController.pushViewController(categoriesViewController, animated: true)
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}

// MARK: - Private

extension CategoriesCoordinator {
    private func onFilmsSelected() {
        let filmsCoordinator = FilmsCoordinator(
            navigationController: navigationController,
            viewControllerFactory: viewControllerFactory
        )
        children.append(filmsCoordinator)
        filmsCoordinator.start()
    }
    
    private func onCharactersSelected() {
        let charactersCoordinator = CharactersCoordinator(
            navigationController: navigationController,
            factory: viewControllerFactory
        )
        children.append(charactersCoordinator)
        charactersCoordinator.start()
    }
}
