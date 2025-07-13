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
        let categoriesViewModel = CategoriesViewModel(categoryService: CategoryServiceImpl())
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.viewModel = categoriesViewModel
        
        categoriesViewController.onCategorySelected = { [weak self] category in
            
            switch category {
            case "films": self?.navigateToFilms()
            case "people": self?.navigateToPeople()
            default: break
            }
        }
        
        navigationController.pushViewController(categoriesViewController, animated: true)
    }

    func navigateToPeople() {
        let peopleCoordinator = PeopleCoordinator(navigationController: navigationController)
        children.append(peopleCoordinator)
        peopleCoordinator.start()
    }

    func navigateToFilms() {
        let filmsCoordinator = FilmsCoordinator(navigationController: navigationController)
        children.append(filmsCoordinator)
        filmsCoordinator.start()
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
