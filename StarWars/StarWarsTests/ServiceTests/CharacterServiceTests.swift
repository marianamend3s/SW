//
//  CharacterServiceTests.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

class CharacterServiceTests: XCTestCase {
    var mockSession: MockNetworkSession!
    let baseURL = "https://swapi.info/api/people/"
    var characterService: CharacterServiceImpl!

    override func setUp() {
        super.setUp()
        
        mockSession = MockNetworkSession()
        characterService = CharacterServiceImpl(urlSession: mockSession, urlString: baseURL)
    }
    
    override func tearDown() {
        mockSession = nil
        characterService = nil
        
        super.tearDown()
    }

    func test_GivenValidResponse_WhenFetchCharacters_ThenCharactersAreSuccessfullyFetched() async throws {
        // GIVEN
        let mockJSON = MockJSON.mockCharacters
        mockSession.mockData = mockJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        // WHEN
        let characters = try await characterService.fetchCharacters()
        
        // THEN
        XCTAssertEqual(characters.count, 2)
        XCTAssertEqual(characters[0].name, "Luke Skywalker")
    }
    
    func test_GivenValidResponse_WhenFetchCharacterFromURL_ThenCharacterIsSuccessFetched() async throws {
        // GIVEN
        let characterURL = URL(string: "https://swapi.info/api/people/1")!
        let mockJSON = MockJSON.mockCharacterFromURL
        mockSession.mockData = mockJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: characterURL, statusCode: 200, httpVersion: nil, headerFields: nil)

        // WHEN
        let character = try await characterService.fetchCharacterFromURL(characterURL)
        
        // THEN
        XCTAssertEqual(character.name, "Luke Skywalker")
    }

    func test_GivenInvalidURL_WhenFetchCharacters_ThenInvalidURLErrorIsThrown() async {
        // GIVEN
        characterService = CharacterServiceImpl(urlSession: mockSession, urlString: "invalid url")

        do {
            // WHEN
            _ = try await characterService.fetchCharacters()
            
            // THEN
            XCTFail("Expected invalidURL error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_GivenInvalidHTTPResponse_WhenFetchCharacters_ThenInvalidResponseErrorIsThrown() async {
        // GIVEN
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)

        do {
            // WHEN
            _ = try await characterService.fetchCharacters()
            
            // THEN
            XCTFail("Expected invalidResponse")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_GivenInvalidJSON_WhenFetchCharacters_ThenDecodingErrorIsThrown() async {
        // GIVEN
        mockSession.mockData = "invalid JSON".data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            // WHEN
            _ = try await characterService.fetchCharacters()
            
            // THEN
            XCTFail("Expected decodingError")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("Wrong error case: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
