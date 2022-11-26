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
        // (x, y, mineCount)
        let pointSequence: [(Int, Int, Int)] = [
            (0, 0, 1),
            (0, 1, 1),
            (0, 2, 0),
            (6, 6, 0),
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

        for (x, y, mineCount) in pointSequence {
            let tile = grid.buttons["Tile (\(x),\(y))"]
            tile.click()

            if mineCount == 0 {
                XCTAssertEqual(tile.label, "Empty")
            } else {
                XCTAssertEqual(tile.label, "\(mineCount) mines nearby")
            }
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
