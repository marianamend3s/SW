//
//  NetworkFetchingService.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

class NetworkFetchingServiceTests: XCTestCase {
    var mockSession: MockNetworkSession!
    var mockURLString: String!

    override func setUp() {
        super.setUp()
        
        mockSession = MockNetworkSession()
        mockURLString = "https://example.com"
    }
    
    override func tearDown() {
        mockSession = nil
        mockURLString = nil
        
        super.tearDown()
    }
    
    func test_GivenValidResponse_WhenFetchDataFromURL_ThenDataSuccessfullyFetched() async throws {
        // GIVEN
        let mockJSON = #"{"name":"Luke Skywalker"}"#
        let mockURL = URL(string: mockURLString)!
        
        mockSession.mockData = mockJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let decoder = JSONDecoder()
        
        let fetcher = NetworkFetchingHelper(urlSession: mockSession, urlString: mockURLString, decoder: decoder)

        // WHEN
        let result = try await fetcher.fetchData(from: mockURL, decodingType: DummyModel.self)
        
        // THEN
        XCTAssertEqual(result, DummyModel(name: "Luke Skywalker"))
    }

    func test_GivenValidResponse_WhenFetchDataFromString_ThenDataSuccessfullyFetched() async throws {
        // GIVEN
        let mockJSON = #"{"name":"Luke Skywalker"}"#
        let mockURL = URL(string: mockURLString)!

        mockSession.mockData = mockJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)

        let decoder = JSONDecoder()
        
        let fetcher = NetworkFetchingHelper(urlSession: mockSession, urlString: mockURLString, decoder: decoder)

        // WHEN
        let result = try await fetcher.fetchData(from: mockURLString, decodingType: DummyModel.self)
        
        // THEN
        XCTAssertEqual(result, DummyModel(name: "Luke Skywalker"))
    }

    func test_GivenInvalidURL_WhenFetchData_ThenInvalidURLErrorIsThrown() async {
        // GIVEN
        let fetcher = NetworkFetchingHelper(urlSession: mockSession, urlString: mockURLString, decoder: JSONDecoder())

        do {
            // WHEN
            _ = try await fetcher.fetchData(from: "invalid url", decodingType: DummyModel.self)
            
            // THEN
            XCTFail("Expected invalidURL error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_GivenInvalidHTTPResponse_WhenFetchData_ThenInvalidResponseErrorIsThrown() async {
        let mockURL = URL(string: mockURLString)!
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(url: mockURL, statusCode: 500, httpVersion: nil, headerFields: nil)

        let fetcher = NetworkFetchingHelper(urlSession: mockSession, urlString: mockURLString, decoder: JSONDecoder())

        do {
            // WHEN
            _ = try await fetcher.fetchData(from: mockURL, decodingType: DummyModel.self)
            
            // THEN
            XCTFail("Expected invalidResponse")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_GivenInvalidJSON_WhenFetchData_ThenDecodingErrorIsThrown() async {
        // GIVEN
        let mockURL = URL(string: mockURLString)!
        mockSession.mockData = "invalid JSON".data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)

        let fetcher = NetworkFetchingHelper(urlSession: mockSession, urlString: mockURLString, decoder: JSONDecoder())

        do {
            // WHEN
            _ = try await fetcher.fetchData(from: mockURL, decodingType: DummyModel.self)
            
            // THEN
            XCTFail("Expected decodingError")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                break // expected
            default:
                XCTFail("Wrong error case: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
