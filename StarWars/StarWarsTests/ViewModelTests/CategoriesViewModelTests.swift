//
//  CategoriesViewModelTests.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

final class CategoriesViewModelTests: XCTestCase {
    var categoriesViewModel: CategoriesViewModel!
    var mockCategoryService: MockCategoryService!
    
    override func setUp() {
        super.setUp()
        
        mockCategoryService = MockCategoryService()
        categoriesViewModel = CategoriesViewModel(categoryService: mockCategoryService)
    }
    
    override func tearDown() {
        categoriesViewModel = nil
        mockCategoryService = nil
        
        super.tearDown()
    }
    
    func test_GivenServiceValidResult_WhenGetCategories_ThenCategoryNamesAreUpdated() {
        // GIVEN
        let expectedCategories = ["films", "starships", "people"]
        mockCategoryService.result = .success(expectedCategories)
        
        let expectation = XCTestExpectation(description: "onCategoriesUpdated expectation")
        
        categoriesViewModel.onCategoriesUpdated = {
            expectation.fulfill()
        }
        
        // WHEN
        categoriesViewModel.getCategories()
        wait(for: [expectation], timeout: 1.0)
        
        // THEN
        XCTAssertEqual(self.categoriesViewModel.categoryNames, expectedCategories)
        
    }
    
    func test_GivenServiceValidResult_WhenGetCategories_ThenLoadingIsTrueThenFalse() {
        // GIVEN
        let expectedCategories = ["films", "starships", "people"]
        mockCategoryService.result = .success(expectedCategories)
        
        let expectation1 = XCTestExpectation(description: "Loading is true")
        let expectation2 = XCTestExpectation(description: "Loading is false")
        
        var loadingStates: [Bool] = []
        categoriesViewModel.onLoadingStateChanged = { isLoading in
            loadingStates.append(isLoading)
            if isLoading {
                expectation1.fulfill()
            } else {
                expectation2.fulfill()
            }
        }
        
        // WHEN
        categoriesViewModel.getCategories()
        
        wait(for: [expectation1, expectation2], timeout: 1.0)
        
        // THEN
        XCTAssertEqual(loadingStates, [true, false])
        XCTAssertFalse(categoriesViewModel.isLoading)
    }
    
    func test_GivenServiceError_WhenGetCategories_ThenErrorMessageIsSet() {
        // GIVEN
        let expectedError = NetworkError.invalidURL
        mockCategoryService.result = .failure(expectedError)
        
        let errorExpectation = XCTestExpectation(description: "onError expectation")
        
        categoriesViewModel.onError = { errorMessage in
            if let receivedErrorMessage = errorMessage {
                errorExpectation.fulfill()
                XCTAssertEqual(receivedErrorMessage, expectedError.localizedDescription)
            }
        }
        
        // WHEN
        categoriesViewModel.getCategories()
        wait(for: [errorExpectation], timeout: 1.0)
        
        // THEN
        XCTAssertNotNil(categoriesViewModel.errorMessage)
        XCTAssertTrue(categoriesViewModel.categoryNames.isEmpty)
    }
}
