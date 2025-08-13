//
//  Character.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

// TODO: make properties Optional for robustness

struct Character: Codable, Hashable {
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: URL
    let films: [URL]
    let species: [URL]
    let vehicles: [URL]
    let starships: [URL]
}

extension Character {
    init() {
        self.name = ""
        self.height = ""
        self.mass = ""
        self.hairColor = ""
        self.skinColor = ""
        self.eyeColor = ""
        self.birthYear = ""
        self.gender = ""
        self.homeworld = URL(string: "https://example.com/homeworld")!
        self.films = []
        self.species = []
        self.vehicles = []
        self.starships = []
    }
}

struct CharacterDisplayItem: Hashable {
    let id: UUID
    let character: Character
    let isPlaceholder: Bool
    
    init(character: Character, isPlaceholder: Bool) {
        self.id = UUID()
        self.character = character
        self.isPlaceholder = isPlaceholder
    }
    
}
