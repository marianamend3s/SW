//
//  Category.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

struct Category: Codable, Hashable {
    let films: URL
    let people: URL
    let planets: URL
    let species: URL
    let vehicles: URL
    let starships: URL
}
