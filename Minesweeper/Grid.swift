//
//  Grid.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import Foundation

protocol Grid {
    associatedtype Tile
//    init(width: Int, height: Int)
    subscript(x: Int, y: Int) -> Tile { get set }
}

struct GameConfiguration {
    let width: Int
    let height: Int
    let minesCount: Int

    static let `default` = GameConfiguration(width: 9, height: 9, minesCount: 10)
}

struct GridFactory {
    func makeGrid(for configuration: GameConfiguration) -> MinesweeperGrid {
        let size = configuration.width * configuration.height
        let emptyCount = size - configuration.minesCount

        let mine = MinesweeperTile(state: .hidden, content: .mine)
        let empty = MinesweeperTile(state: .hidden, content: .empty)
        var grid: [MinesweeperGrid.Tile] = Array(repeating: mine, count: configuration.minesCount) + Array(repeating: empty, count: emptyCount)
        grid.shuffle()
        return MinesweeperGrid(
            width: configuration.width,
            height: configuration.height,
            grid: grid
        )
    }
}

struct MinesweeperGrid: Grid {
    typealias Tile = MinesweeperTile

    let width: Int
    let height: Int
    private var grid: [Tile]

    fileprivate init(width: Int, height: Int, grid: [Tile]) {
        self.width = width
        self.height = height
        self.grid = grid
    }

    subscript(x: Int, y: Int) -> Tile {
        get {
            grid[y * width + x]
        }
        set(newValue) {
            grid[y * width + x] = newValue
        }
    }
}

struct MinesweeperTile {
    var state: State
    var content: Content

    enum State {
        case hidden
        case flagged
        case questionMark
        case exposed
    }

    enum Content {
        case mine
        case empty
    }
}
