//
//  GetWeatherDataTests.swift
//  OpenWeatherAppTests
//
//  Created by Hugo Hernando Bernal Palacio on 8/12/20.
//

import XCTest
@testable import OpenWeatherApp

class GetWeatherDataTests: XCTestCase {

    var sut: GetWeatherDataAdapter!

    override func setUp() {
        super.setUp()

        sut = GetWeatherDataAdapter(dependencies: .init(weatherService: MockWeatherService()))
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func test_GetWeatherData_GetWeatherDataByName_Succeeds() {
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

    func test_GetWeatherData_GetWeatherDataByName_Fails() {
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

    func test_WeatherData_GetWeatherDataForCoordinates_Succeeds() {
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

    func test_WeatherData_GetWeatherDataForCoordinates_Fails() {
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


class MockWeatherService: WeatherDataService {
    func getWeatherData(by name: String, onCompletion: @escaping GetWeatherDataCompletion) {
        name == "Santiago" ? onCompletion(.success(Weather.mock)) : onCompletion(.failure(NetworkClientError.invalidURLResponse))
    }

    func getWeatherData(for coordinates: LocationCoordinates, onCompletion: @escaping GetWeatherDataCompletion) {
        coordinates.latitude == "-33.4" && coordinates.longitude == "-70.6" ? onCompletion(.success(.mock)) : onCompletion(.failure(StoreErrors.unableToGetDataFromStore))
    }
}
