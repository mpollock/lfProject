//
//  Github_ListUITests.swift
//  Github ListUITests
//
//  Created by Michael on 7/14/25.
//

import XCTest

final class Github_ListUITests: XCTestCase {
    func testSearchFlowDisplaysUsersAndOpensDetails() {
        let app = XCUIApplication()
        app.launchArguments = ["-UITest_useMockService"]
        app.launch()

        let searchField = app.searchFields["Search users..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("mpollock\n")

        let cell = app.staticTexts["Michael Pollock"]
        XCTAssertTrue(cell.waitForExistence(timeout: 2))

        cell.tap()

        let title = app.navigationBars["mpollock"]
        XCTAssertTrue(title.waitForExistence(timeout: 2))

        let loginText = app.staticTexts["@mpollock"]
        XCTAssertTrue(loginText.waitForExistence(timeout: 2))

        let locationLabel = app.staticTexts["Durham, NC"]
        XCTAssertTrue(locationLabel.waitForExistence(timeout: 2))

        let bioText = app.staticTexts["Software Engineer excited to build things for Livefront. Wants to test what happens when putting long text here. Blah blah blah blah blah. Lorem ipsuem, etcetera"]
        XCTAssertTrue(bioText.waitForExistence(timeout: 2))
    }
}
