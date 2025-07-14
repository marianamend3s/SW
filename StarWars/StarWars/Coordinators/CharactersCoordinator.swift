//
//  CharactersCoordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

class CharactersCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let charactersViewModel = CharacterViewModel(characterService: CharacterServiceImpl())
        let charactersViewController = CharactersViewController()
        charactersViewController.viewModel = charactersViewModel
        navigationController.pushViewController(charactersViewController, animated: true)
    }
    
    // TODO: Navigate to character details
//    func navigateToCharacterDetail(character: Character) {
//    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
