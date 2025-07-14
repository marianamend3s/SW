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
