//
//  Films.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

struct Film: Codable {
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

    enum CodingKeys: String, CodingKey {
        case title
        case episodeId = "episode_id"
        case openingCrawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case characters
        case planets
        case starships
        case vehicles
        case species
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        episodeId = try container.decode(Int.self, forKey: .episodeId)
        openingCrawl = try container.decode(String.self, forKey: .openingCrawl)
        director = try container.decode(String.self, forKey: .director)
        producer = try container.decode(String.self, forKey: .producer)
        
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            releaseDate = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .releaseDate,
                in: container,
                debugDescription: "Date string does not match format yyyy-MM-dd"
            )
        }
        
        characters = try container.decode([URL].self, forKey: .characters)
        planets = try container.decode([URL].self, forKey: .planets)
        starships = try container.decode([URL].self, forKey: .starships)
        vehicles = try container.decode([URL].self, forKey: .vehicles)
        species = try container.decode([URL].self, forKey: .species)
    }
}
