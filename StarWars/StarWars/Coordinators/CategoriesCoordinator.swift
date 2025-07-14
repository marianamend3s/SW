//
//  CategoriesCoordinator.swift
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
    
    private func onFilmsSelected() {
        let filmsCoordinator = FilmsCoordinator(navigationController: navigationController)
        children.append(filmsCoordinator)
        filmsCoordinator.start()
    }
    
    private func onCharactersSelected() {
        let charactersCoordinator = CharactersCoordinator(navigationController: navigationController)
        children.append(charactersCoordinator)
        charactersCoordinator.start()
    }
}
