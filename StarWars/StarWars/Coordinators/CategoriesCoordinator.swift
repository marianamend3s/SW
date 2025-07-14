//
//  CoordinatorImpl.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

class CategoriesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let categoriesService = CategoryServiceImpl()
        let categoriesViewModel = CategoriesViewModel(categoryService: categoriesService)
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.viewModel = categoriesViewModel
        
        categoriesViewController.onCategorySelected = { [weak self] category in
            
            switch category {
            case "films": self?.navigateToFilms()
            case "people": self?.navigateToCharacters()
            default: break
            }
        }
        
        navigationController.pushViewController(categoriesViewController, animated: true)
    }

    func navigateToFilms() {
        let filmsCoordinator = FilmsCoordinator(navigationController: navigationController)
        children.append(filmsCoordinator)
        filmsCoordinator.start()
    }
    
    func navigateToCharacters() {
        let charactersCoordinator = CharactersCoordinator(navigationController: navigationController)
        children.append(charactersCoordinator)
        charactersCoordinator.start()
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
