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

class CategoryServiceImpl: NetworkService, CategoryService {
    let urlSession: URLSession
    let urlString: String
    let decoder: JSONDecoder
    
    init(
        urlSession: URLSession = .shared,
        urlString: String = "https://swapi.info/api/",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.urlString = urlString
        self.decoder = decoder
    }
    
    func fetchCategoryNames() async throws -> [String] {
        do {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await self.urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let categoryEndpoints = try decoder.decode([String: URL].self, from: data)
            
            return categoryEndpoints.keys.sorted()
            
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
