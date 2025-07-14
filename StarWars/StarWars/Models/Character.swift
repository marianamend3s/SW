//
//  Character.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

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
