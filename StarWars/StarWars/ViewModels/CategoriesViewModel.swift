//
//  CategoriesViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

class CategoriesViewModel {
    weak var coordinator: CategoriesCoordinator?

    init(coordinator: CategoriesCoordinator) {
        self.coordinator = coordinator
    }

    func didSelectCategory(at indexPath: IndexPath, with name: String) {
        switch name {
        case Categories.films.rawValue:
            coordinator?.navigateToFilms()
        default:
            break
        }
    }
}
