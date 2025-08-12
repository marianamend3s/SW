//
//  MockCategoryService.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

class MockCategoryService: CategoryService {
    var result: Result<Categories, Error>!

    func fetchCategories() async throws -> Categories {
        switch result {
        case .success(let categories):
            return categories
        case .failure(let error):
            throw error
        case .none:
            fatalError("Fatal error")
        }
    }
}
