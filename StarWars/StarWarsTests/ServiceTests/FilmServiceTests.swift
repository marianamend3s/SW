//
//  FilmServiceTests.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

class FilmServiceTests: XCTestCase {
    var mockSession: MockNetworkSession!
    let baseURL = "https://swapi.info/api/films/"
    var filmService: FilmServiceImpl!

    override func setUp() {
        super.setUp()
        
        mockSession = MockNetworkSession()

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        filmService = FilmServiceImpl(urlSession: mockSession, urlString: baseURL, decoder: decoder)
    }

    override func tearDown() {
        super.tearDown()
        
        mockSession = nil
        filmService = nil
    }
    
    func test_GivenValidResponse_WhenFetchFilms_ThenFilmsAreSuccessfullyFetched() async throws {
        // GIVEN
        let mockJSON = MockJSON.mockFilms
        mockSession.mockData = mockJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // WHEN
        let films = try await filmService.fetchFilms()
        
        // THEN
        XCTAssertEqual(films.count, 2)
        XCTAssertEqual(films[0].title, "A New Hope")
        
    }

    
    func test_GivenInvalidURL_WhenFetchFilms_ThenInvalidURLErrorIsThrown() async {
        // GIVEN
        filmService = FilmServiceImpl(urlSession: mockSession, urlString: "invalid url")
        
        do {
            // WHEN
            _ = try await filmService.fetchFilms()
            
            // THEN
            XCTFail("Expected invalidURL error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_GivenInvalidHTTPResponse_WhenFetchFilms_ThenInvalidResponseErrorIsThrown() async {
        // GIVEn
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: baseURL)!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            // WHEN
            _ = try await filmService.fetchFilms()
            
            // THEN
            XCTFail("Expected invalidResponse error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_GivenInvalidJSON_WhenFetchFilms_ThenDecodingErrorIsThrown() async {
        // GIVEN
        mockSession.mockData = "invalid json".data(using: .utf8)!
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            // WHEN
            _ = try await filmService.fetchFilms()
            
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
