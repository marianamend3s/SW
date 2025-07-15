//
//  CategoryServiceTests.swift
//  StarWarsTests
//
//  Created by Mariana Mendes on 15/07/2025.
//

import XCTest
@testable import StarWars

class CategoryServiceTests: XCTestCase {
    var mockSession: MockNetworkSession!
    let baseURL = "https://swapi.info/api/"
    var categoryService: CategoryServiceImpl!

    override func setUp() {
        super.setUp()
        
        mockSession = MockNetworkSession()
        categoryService = CategoryServiceImpl(urlSession: mockSession, urlString: baseURL)
    }
    
    override func tearDown() {
        mockSession = nil
        categoryService = nil
        
        super.tearDown()
    }
    
    func test_GivenValidResponse_WhenFetchCategoryNames_ThenCategoryNamesAreSuccessfullyFetched() async throws {
        // GIVEN
        let mockJSON = MockJSON.mockCategories
        mockSession.mockData = mockJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        // WHEN
        let categories = try await categoryService.fetchCategoryNames()
        
        // THEN
        XCTAssertEqual(categories, ["films", "people"].sorted())
    }

    func test_GivenInvalidURL_WhenFetchCategoryNames_ThenInvalidURLErrorIsThrown() async {
        // GIVEN
        categoryService = CategoryServiceImpl(urlString: "invalid url")
        
        do {
            // WHEN
            _ = try await categoryService.fetchCategoryNames()
            
            // THEN
            XCTFail("Expected invalidURL error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_GivenInvalidHTTPResponse_WhenFetchCategoryNames_ThenInvalidResponseErrorIsThrown() async {
        // GIVEN
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://swapi.info/api/")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            // WHEN
            _ = try await categoryService.fetchCategoryNames()
            
            // THEN
            XCTFail("Expected invalidResponse error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_GivenInvalidJSON_WhenFetchCategoryNames_ThenDecodingErrorIsThrown() async {
        // GIVEN
        mockSession.mockData = "invalid JSON".data(using: .utf8)!
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://swapi.info/api/")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            // WHEN
            _ = try await categoryService.fetchCategoryNames()
            
            // THEN
            XCTFail("Expected decodingError")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("Unexpected NetworkError case: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
