//
//  FilmsViewModelTests.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

final class FilmsViewModelTests: XCTestCase {
    var filmsViewModel: FilmsViewModel!
    var mockFilmService: MockFilmService!
    var film1: Film!
    var film2: Film!
    
    override func setUp() {
        super.setUp()
        
        mockFilmService = MockFilmService()
        filmsViewModel = FilmsViewModel(filmsService: mockFilmService)
        
        film1 = Film(
            title: "Film1",
            episodeId: 1,
            openingCrawl: "",
            director: "",
            producer: "",
            releaseDate: Date(),
            characters: [],
            planets: [],
            starships: [],
            vehicles: [],
            species: []
        )
        
        film2 = Film(
            title: "Film2",
            episodeId: 2,
            openingCrawl: "",
            director: "",
            producer: "",
            releaseDate: Date(),
            characters: [],
            planets: [],
            starships: [],
            vehicles: [],
            species: []
        )
    }
    
    override func tearDown() {
        filmsViewModel = nil
        mockFilmService = nil
        
        super.tearDown()
    }
    
    func test_GivenServiceValidResult_WhenGetFilms_ThenFilmsAreUpdatedAndOrdered() {
        // GIVEN
        guard let film1, let film2 else { return }
        let unorderedFilms = [film2, film1]
        let expectedOrderedFilms = [film1, film2]
        
        mockFilmService.result = .success(unorderedFilms)
        
        let expectation = XCTestExpectation(description: "onFilmsUpdated expectation")
        
        filmsViewModel.onFilmsUpdated = {
            expectation.fulfill()
        }
        
        // WHEN
        filmsViewModel.getFilms()
        wait(for: [expectation], timeout: 1.0)
        
        // THEN
        XCTAssertEqual(self.filmsViewModel.films, expectedOrderedFilms)
    }
    
    func test_GivenServiceValidResult_WhenGetFilms_ThenLoadingIsTrueThenFalse() {
        // GIVEN
        mockFilmService.result = .success([film1, film2])
        
        let expectation1 = XCTestExpectation(description: "Loading is true")
        let expectation2 = XCTestExpectation(description: "Loading is false")
        
        var loadingStates: [Bool] = []
        filmsViewModel.onLoadingStateChanged = { isLoading in
            loadingStates.append(isLoading)
            if isLoading {
                expectation1.fulfill()
            } else {
                expectation2.fulfill()
            }
        }
        
        // WHEN
        filmsViewModel.getFilms()
        wait(for: [expectation1, expectation2], timeout: 1.0)
        
        // THEN
        XCTAssertEqual(loadingStates, [true, false])
        XCTAssertFalse(filmsViewModel.isLoading)
    }
    
    func test_GivenServiceError_WhenGetFilms_ThenErrorMessageIsSet() {
        // GIVEN
        let expectedError = NetworkError.invalidURL
        mockFilmService.result = .failure(expectedError)
        
        let errorExpectation = XCTestExpectation(description: "onError expectation")
        
        filmsViewModel.onError = { errorMessage in
            if let receivedErrorMessage = errorMessage {
                errorExpectation.fulfill()
                XCTAssertEqual(receivedErrorMessage, expectedError.localizedDescription)
            }
        }
        
        // WHEN
        filmsViewModel.getFilms()
        wait(for: [errorExpectation], timeout: 1.0)
        
        // THEN
        XCTAssertNotNil(filmsViewModel.errorMessage)
        XCTAssertTrue(filmsViewModel.films.isEmpty)
    }
}
