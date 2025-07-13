//
//  CoordinatorImpl.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

class CoordinatorImpl: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let categoriesCoordinator = CategoriesCoordinator(navigationController: navigationController)
        children.append(categoriesCoordinator)
        categoriesCoordinator.start()
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
