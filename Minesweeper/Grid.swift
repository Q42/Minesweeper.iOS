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

    struct Point: Hashable, Equatable {
        let x: Int
        let y: Int
    }

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

    private func isInBounds(x: Int, y: Int) -> Bool {
        return x >= 0 && x < width &&
               y >= 0 && y < height
    }

    func adjacentPoints(x: Int, y: Int) -> [Point] {
        var result: [Point] = []
        for relX in (-1...1) {
            for relY in (-1...1) {
                let absX = x + relX
                let absY = y + relY
                if !(relX == 0 && relY == 0) && isInBounds(x: absX, y: absY) {
                    result.append(Point(x: absX, y: absY))
                }
            }
        }
        return result
    }

    func adjacentTiles(x: Int, y: Int) -> [Tile] {
        adjacentPoints(x: x, y: y)
            .map { point in
                self[point.x, point.y]
            }
    }

    func mineCount(x: Int, y: Int) -> Int {
        adjacentTiles(x: x, y: y)
            .filter { tile in
                tile.content == .mine
            }
            .count
    }
    
    private func findZeroesConnectedTo(x: Int, y: Int) -> Set<Point> {
        var set = Set<Point>()
        for point in adjacentPoints(x: x, y: y) {
            if mineCount(x: point.x, y: point.y) == 0 {
                set.insert(point)
                if !set.contains(point) {
                    set = set.union(findZeroesConnectedTo(x: point.x, y: point.y))
                }
            }
        }
        return set
    }
    
    mutating func markSweep(x: Int, y: Int) {
        let zeroes = findZeroesConnectedTo(x: x, y: y)
        var newGrid = self
        for point in zeroes {
            newGrid[point.x, point.y].state = .exposed
            for point in adjacentPoints(x: point.x, y: point.y) {
                newGrid[point.x, point.y].state = .exposed
            }
        }
        self = newGrid
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
