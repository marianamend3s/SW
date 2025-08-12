//
//  CategoryService.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

protocol CategoryService {
    func fetchCategories() async throws -> Categories
}

class CategoryServiceImpl: NetworkFetchingService, CategoryService {
    let urlSession: NetworkSession
    let urlString: String
    let decoder: JSONDecoder
    
    init(
        urlSession: NetworkSession = URLSession.shared,
        urlString: String = "https://swapi.info/api/",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.urlString = urlString
        self.decoder = decoder
    }
    
    func fetchCategories() async throws -> Categories {
        return try await fetchData(from: urlString, decodingType: Categories.self)
    }
}
