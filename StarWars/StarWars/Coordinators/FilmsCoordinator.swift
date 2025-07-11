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
        //let viewModel = FilmsViewModel()
        let viewController = FilmsViewController()
       // viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // TODO: 
    func navigateToFilmDetails() {
        print("DEBUG: Navigating to film details")
    }
}
