//
//  MinesweeperTests.swift
//  MinesweeperTests
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import XCTest
@testable import Minesweeper

class MinesweeperTests: XCTestCase {
    func testMakeGrid() throws {
        let factory = SeededRandomGridFactory(seed: "testing".data(using: .utf8))
        let grid = factory.makeGrid(for: .beginner)
        XCTAssertEqual(grid.width, 9)
        XCTAssertEqual(grid.height, 9)
    }

    func testMakeGridWithSeed() throws {
        let seed = "testing".data(using: .utf8)

        let factory1 = SeededRandomGridFactory(seed: seed)
        let grid1 = factory1.makeGrid(for: .beginner)

        let factory2 = SeededRandomGridFactory(seed: seed)
        let grid2 = factory2.makeGrid(for: .beginner)
        XCTAssertEqual(grid1, grid2)
    }
}
