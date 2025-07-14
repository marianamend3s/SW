//
//  Character.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

struct Character: Codable {
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

    enum CodingKeys: String, CodingKey {
        case name
        case height
        case mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender
        case homeworld
        case films
        case species
        case vehicles
        case starships

    }
}
