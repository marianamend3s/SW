//
//  MainCoordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

final class MainCoordinator: Coordinator {
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
        let categoriesCoordinator = CategoriesCoordinator(
            navigationController: navigationController,
            viewControllerFactory: viewControllerFactory
        )
        children.append(categoriesCoordinator)
        categoriesCoordinator.start()
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
