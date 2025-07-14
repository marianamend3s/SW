//
//  Films.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

struct Film: Codable, Hashable {
    let title: String
    let episodeId: Int
    let openingCrawl: String
    let director: String
    let producer: String
    let releaseDate: Date
    let characters: [URL]
    let planets: [URL]
    let starships: [URL]
    let vehicles: [URL]
    let species: [URL]
}
