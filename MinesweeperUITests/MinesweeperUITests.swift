//
//  MinesweeperUITests.swift
//  MinesweeperUITests
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import XCTest

class MinesweeperUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launchArguments = ["-seed", "hakvoort!"]
        app.launch()

        // Start new game
        #if os(macOS)
        app.menuBars.menuItems["Beginner"].click()
        #else
        app.buttons["Beginner"].tap()
        #endif
    }

    /// Plays through a pre-determined game. Due to the seed that is passed to the app,
    /// the board is the same every time.
    func testPlayGame() {
        #if os(macOS)
        let toolbar = app.windows.firstMatch.toolbars
        let grid = app.windows.firstMatch.groups["Grid"]
        #else
        let toolbar = app.navigationBars
        let grid = app.otherElements["Grid"]
        #endif

        XCTAssertTrue(grid.exists)

        grid.buttons["Tile (0,0)"].clickOrTap()
        grid.buttons["Tile (0,1)"].clickOrTap()
        grid.buttons["Tile (0,2)"].clickOrTap()

        toolbar.buttons["Flag"].clickOrTap()
        grid.buttons["Tile (1,0)"].clickOrTap()
        toolbar.buttons["Remove Flag"].clickOrTap()

        grid.buttons["Tile (2,0)"].clickOrTap()

        toolbar.buttons["Flag"].clickOrTap()
        grid.buttons["Tile (3,0)"].clickOrTap()
        toolbar.buttons["Remove Flag"].clickOrTap()

        grid.buttons["Tile (4,0)"].clickOrTap()
        grid.buttons["Tile (6,4)"].clickOrTap()

        toolbar.buttons["Flag"].clickOrTap()
        grid.buttons["Tile (2,1)"].clickOrTap()
        grid.buttons["Tile (0,6)"].clickOrTap()
        grid.buttons["Tile (8,6)"].clickOrTap()
        grid.buttons["Tile (7,7)"].clickOrTap()
        toolbar.buttons["Remove Flag"].clickOrTap()

        grid.buttons["Tile (8,7)"].clickOrTap()
        grid.buttons["Tile (7,8)"].clickOrTap()

        toolbar.buttons["Flag"].clickOrTap()
        grid.buttons["Tile (8,8)"].clickOrTap()
        toolbar.buttons["Remove Flag"].clickOrTap()

        grid.buttons["Tile (2,4)"].clickOrTap()

//        app.windows.firstMatch.sheets.buttons["View board"].click()
    }
}

extension XCUIElement {
    func clickOrTap() {
        #if os(macOS)
        click()
        #else
        tap()
        #endif
    }
}
