//
//  MinesweeperTests.swift
//  MinesweeperTests
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import XCTest
@testable import Minesweeper

final class MinesweeperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let factory = SeededRandomGridFactory(seed: "testing".data(using: .utf8))
        let grid = factory.makeGrid(for: .beginner)
        XCTAssertEqual(grid.width, 9)
        XCTAssertEqual(grid.height, 9)
    }

}
