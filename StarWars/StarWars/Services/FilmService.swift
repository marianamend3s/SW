//
//  FilmService.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

protocol FilmService {
    func fetchFilms() async throws -> [Film]
}

class FilmServiceImpl: NetworkFetchingService, FilmService {
    let urlSession: NetworkSession
    let urlString: String
    let decoder: JSONDecoder
    
    init(
        urlSession: NetworkSession = URLSession.shared,
        urlString: String = "https://swapi.info/api/films/",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.urlString = urlString
        self.decoder = decoder
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchFilms() async throws -> [Film] {
        return try await fetchData(from: urlString, decodingType: [Film].self)
    }
}
