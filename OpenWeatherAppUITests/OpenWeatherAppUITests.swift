//
//  OpenWeatherAppUITests.swift
//  OpenWeatherAppUITests
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import XCTest

class OpenWeatherAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil

        super.tearDown()
    }

    func test_CitiesViewController_ScrollsCorrectly() {
        // Given
        XCTAssert(app.collectionViews["XCTCollectionView"].firstMatch.waitForExistence(timeout: 5), "CitiesViewController should be visible")

        // When
        app.collectionViews["XCTCollectionView"].firstMatch.swipeUp()

        // Then
        XCTAssert(app.staticTexts.element(matching: .init(format: "label == %@", "Roma")).waitForExistence(timeout: 5)  , "Cell with label Roma should be visible")
    }

    func test_CitiesViewController_PressItem_ShowsDetailView() {
        // Given
        app.collectionViews["XCTCollectionView"].firstMatch.swipeUp()

        // When
        app.staticTexts.element(matching: .init(format: "label == %@", "Roma")).press(forDuration: 0.01)

        // Then
        XCTAssert(app.staticTexts["XCTempLabel"].firstMatch.waitForExistence(timeout: 10))
    }

    func test_WeatherDetailViewController_PressBackButton_ReturnsToCitiesViewController() {
        // Given
        app.collectionViews["XCTCollectionView"].firstMatch.swipeUp()
        app.staticTexts.element(matching: .init(format: "label == %@", "Roma")).press(forDuration: 0.01)
        XCTAssert(app.staticTexts["XCTempLabel"].firstMatch.waitForExistence(timeout: 10))

        // When
        app.buttons.firstMatch.press(forDuration: 0.01)
        
        // Then
        XCTAssert(app.collectionViews["XCTCollectionView"].firstMatch.waitForExistence(timeout: 5), "CitiesViewController should be visible")
    }
}
