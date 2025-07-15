//
//  CharacterViewUnitTests.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

final class CharacterViewModelTests: XCTestCase {
    var characterViewModel: CharacterViewModel!
    var mockCharacterService: MockCharacterService!
    
    override func setUp() {
        super.setUp()
        
        mockCharacterService = MockCharacterService()
        characterViewModel = CharacterViewModel(characterService: mockCharacterService)
    }
    
    override func tearDown() {
        characterViewModel = nil
        mockCharacterService = nil
        
        super.tearDown()
    }
    
    func test_GivenServiceValidResult_WhenGetCharacters_ThenInitialPageIsLoaded() {
        // GIVEN
        let allTestCharacters: [Character] = (1...25).map {
            createTestCharacter(name: "Character \($0)", episode: $0)
        }
        let viewModelPageSize = 20
        let expectedFirstPage = Array(allTestCharacters[0..<viewModelPageSize])
        
        mockCharacterService.fetchCharactersResult = .success(allTestCharacters)
        
        let expectation = XCTestExpectation(description: "onCharactersUpdated expectation")
        
        characterViewModel.onCharactersUpdated = {
            expectation.fulfill()
        }
        
        // WHEN
        characterViewModel.getCharacters()
        wait(for: [expectation], timeout: 1.0)
        
        // THEN
        XCTAssertEqual(characterViewModel.pageCharacters, expectedFirstPage)
        XCTAssertFalse(characterViewModel.isLoading)
        XCTAssertNil(characterViewModel.errorMessage)
    }
    
    func test_GivenServiceError_WhenGetCharacters_ThenErrorIsThrown() {
        // GIVEN
        let expectedError = NetworkError.invalidURL
        mockCharacterService.fetchCharactersResult = .failure(expectedError)
        
        let errorExpectation = XCTestExpectation(description: "onError expectation")
        
        characterViewModel.onError = { errorMessage in
            if let receivedErrorMessage = errorMessage {
                XCTAssertEqual(receivedErrorMessage, expectedError.localizedDescription)
                errorExpectation.fulfill()
            }
        }
        
        // WHEN
        characterViewModel.getCharacters()
        wait(for: [errorExpectation], timeout: 1.0)
        
        // THEN
        XCTAssertNotNil(self.characterViewModel.errorMessage)
        XCTAssertTrue(self.characterViewModel.pageCharacters.isEmpty)
        XCTAssertFalse(characterViewModel.isLoading)
    }
    
    func test_GivenServiceValidResult_WhenGetCharacters_ThenLoadingIsTrueThenFalse() {
        // GIVEN
        mockCharacterService.fetchCharactersResult = .success([createTestCharacter(name: "Luke Skywalker", episode: 1)])
        
        let expectationForTrue = XCTestExpectation(description: "Loading is true")
        let expectationForFalse = XCTestExpectation(description: "Loading is false")
        
        var loadingStates: [Bool] = []
        characterViewModel.onLoadingStateChanged = { isLoading in
            loadingStates.append(isLoading)
            if isLoading {
                expectationForTrue.fulfill()
            } else {
                expectationForFalse.fulfill()
            }
        }
        
        // WHEN
        characterViewModel.getCharacters()
        wait(for: [expectationForTrue, expectationForFalse], timeout: 1.0)
        
        // THEN
        XCTAssertEqual(loadingStates, [true, false])
        XCTAssertFalse(characterViewModel.isLoading)
    }
}
    
// MARK: - Helper

extension CharacterViewModelTests {
    private func createTestCharacter(name: String, episode: Int = 1) -> Character {
        return Character(
            name: name,
            height: "170",
            mass: "70",
            hairColor: "brown",
            skinColor: "light",
            eyeColor: "blue",
            birthYear: "19BBY",
            gender: "male",
            homeworld: URL(string: "https://swapi.dev/api/planets/\(episode)/")!,
            films: [URL(string: "https://swapi.dev/api/films/\(episode)/")!],
            species: [],
            vehicles: [],
            starships: []
        )
    }
}
