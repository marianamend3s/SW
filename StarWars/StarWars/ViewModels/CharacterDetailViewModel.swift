//
//  CharacterDetailViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 14/07/2025.
//

import Foundation

class CharacterDetailViewModel {
    private let character: Character

    init(character: Character) {
        self.character = character
    }

    var name: String { character.name }
    var height: String { "\(character.height) cm" }
    var mass: String { "\(character.mass) kg" }
    var hairColor: String { character.hairColor.capitalized }
    var skinColor: String { character.skinColor.capitalized }
    var eyeColor: String { character.eyeColor.capitalized }
    var birthYear: String { character.birthYear }
    var gender: String { character.gender.capitalized }
    var filmCount: Int { character.films.count }
    var vehicleCount: Int { character.vehicles.count }
    var starshipCount: Int { character.starships.count }
}
