//
//  PeopleCoordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

class PeopleCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = PeopleViewModel(peopleService: PeopleServiceImpl())
        let viewController = PeopleViewController()
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // TODO: Navigate to people details
//    func navigateToPeopleDetail(people: People) {
//    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
