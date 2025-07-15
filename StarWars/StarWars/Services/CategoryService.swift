//
//  CategoryService.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

protocol CategoryService {
    func fetchCategoryNames() async throws -> [String]
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
    
    func fetchCategoryNames() async throws -> [String] {
        let categoryEndpoints = try await fetchData(from: urlString, decodingType: [String: URL].self)
        
        return categoryEndpoints.keys.sorted()
    }
}
