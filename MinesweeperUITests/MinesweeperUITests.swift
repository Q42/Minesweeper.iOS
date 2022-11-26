//
//  MinesweeperUITests.swift
//  MinesweeperUITests
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import XCTest

final class MinesweeperUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // (x, y, label)
        let pointSequence: [(Int, Int, String)] = [
            (0, 0, "1 mines nearby"),
            (0, 1, "1 mines nearby"),
            (0, 2, "Empty"),
            (6, 6, "Empty"),
        ]

        let app = XCUIApplication()
        app.launchArguments = ["-seed", "hakvoort!"]
        app.launch()

        #if os(macOS)
        let grid = app.windows["Minesweeper"].groups["Grid"]
        #else
        let grid = app.otherElements["Grid"]
        #endif
        XCTAssertTrue(grid.exists)

        for (x, y, expectedLabel) in pointSequence {
            let tile = grid.buttons["Tile (\(x),\(y))"]

            #if os(macOS)
            tile.click()
            #else
            tile.tap()
            #endif

            XCTAssertEqual(tile.label, expectedLabel)
        }
    }
}
