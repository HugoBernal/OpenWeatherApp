//
//  WeatherDataServiceTests.swift
//  OpenWeatherAppTests
//
//  Created by Hugo Hernando Bernal Palacio on 8/12/20.
//

import XCTest
@testable import OpenWeatherApp

class WeatherDataServiceTests: XCTestCase {

    var sut: WeatherDataServiceAdapter!

    override func setUp() {
        super.setUp()

        sut = WeatherDataServiceAdapter(dependencies: .init(networkClient: MockNetworkClient(),
                                                            storeManager: MockStoreManager()))
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func test_WeatherDataService_GetWeatherDataByName_Succeeds() {
        // Given
        let expectedName = "Santiago"
        let testExpectation = expectation(description: "Get weather by name succeeds!")

        // When
        sut.getWeatherData(by: expectedName) { result in
            switch result {
            case .success(let weather):
                // Then
                testExpectation.fulfill()

                XCTAssertTrue(weather.name == expectedName, "City name should've matche expected name")
            case .failure(_):
                XCTFail("Test should've succeed")
            }
        }

        waitForExpectations(timeout: 5)
    }

    func test_WeatherDataService_GetWeatherDataByName_Fails() {
        // Given
        let expectedName = "Caracas"
        let testExpectation = expectation(description: "Get weather by name fails")

        // When
        sut.getWeatherData(by: expectedName) { result in
            switch result {
            case .success(_):
                XCTFail("Test should've failed")
            case .failure(let error):
                // Then
                testExpectation.fulfill()

                XCTAssertNotNil(error, "Test should've failed with valid error")
            }
        }

        waitForExpectations(timeout: 5)
    }

    func test_WeatherDataService_GetWeatherDataForCoordinates_Succeeds() {
        // Given
        let expectedCoordinates: LocationCoordinates = .init(latitude: "-33.4", longitude: "-70.6")
        let testExpectation = expectation(description: "Get weather for coordinates succeeds!")

        // When
        sut.getWeatherData(for: expectedCoordinates) { result in
            switch result {
            case .success(let weather):
                // Then
                testExpectation.fulfill()

                XCTAssertNotNil(weather, "Request should've succeeded with valid weather data")
            case .failure(_):
                XCTFail("Test should've succeed")
            }
        }

        waitForExpectations(timeout: 5)
    }

    func test_WeatherDataService_GetWeatherDataForCoordinates_Fails() {
        // Given
        let expectedCoordinates: LocationCoordinates = .init(latitude: "30.8", longitude: "110.2")
        let testExpectation = expectation(description: "Get weather for coordinates fails!")

        // When
        sut.getWeatherData(for: expectedCoordinates) { result in
            switch result {
            case .success(_):
                XCTFail("Test should've failed")
            case .failure(let error):
                // Then
                testExpectation.fulfill()

                XCTAssertNotNil(error, "Test should've failed with valid error")
            }
        }

        waitForExpectations(timeout: 5)
    }
}
