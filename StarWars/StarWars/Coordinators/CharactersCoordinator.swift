//
//  CharactersCoordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

final class CharactersCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children: [Coordinator] = []
    let factory: ViewControllerFactory
    
    init(
        navigationController: UINavigationController,
        factory: ViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let charactersViewController = factory.makeCharactersViewController()
        
        charactersViewController.onCharacterSelected = { [weak self] character in
            self?.navigateToCharacterDetail(character: character)
        }
        
        navigationController.pushViewController(charactersViewController, animated: true)
    }
    
    func navigateToCharacterDetail(character: Character) {
        let characterDetailViewModel = CharacterDetailViewModel(character: character)
        
        let characterDetailViewController = CharacterDetailViewController()
        characterDetailViewController.viewModel = characterDetailViewModel
        
        navigationController.pushViewController(characterDetailViewController, animated: true)
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
}
