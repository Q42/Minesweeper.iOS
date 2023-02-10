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
    }

    enum Level: String {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case expert = "Expert"
    }

    func startGame(level: Level) {
        #if os(macOS)
        app.menuBars.menuItems[level.rawValue].click()
        #else
        app.buttons[level.rawValue].tap()
        #endif
    }

    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Plays through a pre-determined game. Due to the seed that is passed to the app,
    /// the board is the same every time.
    func testPlayBeginnerGame() {
        startGame(level: .beginner)

        #if os(macOS)
        let toolbar = app.windows.firstMatch.toolbars
        let grid = app.windows.firstMatch.groups["Grid"]
        #else
        let toolbar = app.navigationBars
        let grid = app.otherElements["Grid"]
        #endif

        XCTAssertTrue(grid.exists, "Grid not found")

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

        takeScreenshot(name: "1_beginner_game")

//        app.windows.firstMatch.sheets.buttons["View board"].click()
    }

    func testPlayExpertGame() {
        startGame(level: .expert)

        #if os(macOS)
        let grid = app.windows.firstMatch.groups["Grid"]
        #else
        let grid = app.otherElements["Grid"]
        #endif

        XCTAssertTrue(grid.exists, "Grid not found")

        #if os(iOS)
        grid.swipeUp()
        grid.swipeLeft()
        #endif

        grid.buttons["Tile (26,12)"].clickOrTap()
        grid.buttons["Tile (29,13)"].clickOrTap()
        takeScreenshot(name: "3_game_over")
        app.buttons["View board"].clickOrTap()
        takeScreenshot(name: "2_expert_game")
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
