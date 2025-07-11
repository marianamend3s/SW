//
//  NetworkServiceTests.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 11/07/2025.
//

import XCTest
@testable import StarWars

class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    var testSession: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        URLSession.shared.configuration.protocolClasses = nil
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSession.self]
        
        testSession = URLSession(configuration: configuration)
        
        sut = NetworkServiceImpl(urlSession: testSession)
        
        MockURLSession.requestHandler = nil
    }
    
    override func tearDownWithError() throws {
        MockURLSession.requestHandler = nil
        sut = nil
        testSession = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Test Cases
    
    func test_GivenAValidResponseAndData_WhenGetFilmsIsCalled_ThenItReturnsFilms() async throws {
        // GIVEN
        let jsonString = """
            [
                {
                    "title": "A New Hope",
                    "episode_id": 4,
                    "opening_crawl": "...",
                    "director": "George Lucas",
                    "producer": "Gary Kurtz, Rick McCallum",
                    "release_date": "1977-05-25",
                    "characters": [],
                    "planets": [],
                    "starships": [],
                    "vehicles": [],
                    "species": [],
                    "created": "2014-12-10T14:23:31.880000Z",
                    "edited": "2014-12-20T19:49:45.256000Z",
                    "url": "https://swapi.info/api/films/1"
                }
            ]
            """
        
        let mockData = jsonString.data(using: .utf8)!
        let mockURL = URL(string: "https://swapi.info/api/films/")!
        let mockResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        MockURLSession.requestHandler = { request in
            return (mockResponse, mockData)
        }
        
        // WHEN
        let films = try await sut.getFilms()
        
        // THEN
        XCTAssertEqual(films.count, 1)
        XCTAssertEqual(films.first?.title, "A New Hope")
        XCTAssertEqual(films.first?.episodeId, 4)
    }
    
    func test_GivenAnInvalidURL_WhenGetFilmsisCalled_ThenReturnsInvalidURLError() async {
        // GIVEN
        let sut = NetworkServiceImpl(urlSession: testSession, filmsURLString: "")
        
        // WHEN
        do {
            _ = try await sut.getFilms()
            XCTFail("Test should have thrown NetworkError.invalidURL, but it succeeded.")
        } catch let error as NetworkError {
            // THEN
            XCTAssertEqual(error, NetworkError.invalidURL)
            XCTAssertTrue(error.localizedDescription.contains("The URL for fetching data was invalid."))

        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_Given404ErrorCode_WhenGetFilmsIsCalled_ThenReturnsInvalidResponseError() async {
        // GIVEN
        let mockURL = URL(string: "https://swapi.info/api/films/")!
        let mockResponse = HTTPURLResponse(url: mockURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let emptyData = Data()
        
        MockURLSession.requestHandler = { request in
            return (mockResponse, emptyData)
        }
        
        // WHEN
        do {
            _ = try await sut.getFilms()
            XCTFail("Test should have thrown NetworkError.invalidResponse, but it succeeded.")
        } catch let error as NetworkError {
            // THEN
            XCTAssertEqual(error, NetworkError.invalidResponse)
            XCTAssertTrue(error.localizedDescription.contains("The server returned an invalid response."))
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_GivenInvalidJSON_WhenGetFilmsIsCalled_ThenReturnsDecodingError() async {
        // GIVEN
        let invalidJsonString = "invalid json format"
        let mockData = invalidJsonString.data(using: .utf8)!
        let mockURL = URL(string: "https://swapi.info/api/films/")!
        let mockResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        MockURLSession.requestHandler = { request in
            return (mockResponse, mockData)
        }
        
        // WHEN
        do {
            _ = try await sut.getFilms()
            XCTFail("Test should have thrown NetworkError.decodingError, but it succeeded.")
        } catch let error as NetworkError {
            // THEN
            if case .decodingError(let wrappedError) = error {
                XCTAssertEqual(error, NetworkError.decodingError(wrappedError))
                XCTAssertTrue(error.localizedDescription.contains("Failed to decode data"))
            } else {
                XCTFail("Unexpected error: \(error.localizedDescription).")
            }
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_GivenNoInternetConnection_WhenGetFilmsIsCalled_ThenReturnsDecodingErrorAsNetworkError() async {
        // GIVEN
        let mockNetworkError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        
        MockURLSession.requestHandler = { request in
            throw mockNetworkError
        }
        
        // WHEN
        do {
            _ = try await sut.getFilms()
            XCTFail("Test should have thrown NetworkError.decodingError, but it succeeded.")
        } catch let error as NetworkError {
            // THEN
            if case .decodingError(let wrappedError) = error {
                XCTAssertEqual(error, NetworkError.decodingError(wrappedError))
                XCTAssertTrue(error.localizedDescription.contains(wrappedError.localizedDescription))
            } else {
                XCTFail("Unexpected error: \(error.localizedDescription).")
            }
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
