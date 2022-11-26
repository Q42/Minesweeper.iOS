//
//  Grid.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import Foundation
import GameKit

struct GameConfiguration {
    let width: Int
    let height: Int
    let minesCount: Int

    private init(width: Int, height: Int, minesCount: Int) {
        self.width = width
        self.height = height
        self.minesCount = minesCount
    }

    static let beginner = GameConfiguration(width: 9, height: 9, minesCount: 10)
    static let intermediate = GameConfiguration(width: 16, height: 16, minesCount: 40)
    static let expert = GameConfiguration(width: 30, height: 16, minesCount: 99)
    static func custom(width: Int, height: Int, minesCount: Int) -> GameConfiguration {
        .init(width: width, height: height, minesCount: minesCount)
    }
    static let `default` = GameConfiguration.beginner
}

protocol GridFactory {
    func makeGrid(for configuration: GameConfiguration) -> MinesweeperGrid
}

struct RandomGridFactory: GridFactory {
    private let randomSource: GKRandomSource

    init(seed: Data? = nil) {
        if let seed {
            randomSource = GKARC4RandomSource(seed: seed)
        } else {
            randomSource = GKARC4RandomSource()
        }
    }

    func makeGrid(for configuration: GameConfiguration) -> MinesweeperGrid {
        let size = configuration.width * configuration.height
        let emptyCount = size - configuration.minesCount

        let mine = MinesweeperTile(state: .hidden, content: .mine)
        let empty = MinesweeperTile(state: .hidden, content: .empty)

        var grid: [MinesweeperTile] = Array(repeating: mine, count: configuration.minesCount) + Array(repeating: empty, count: emptyCount)
        if let shuffled = randomSource.arrayByShufflingObjects(in: grid) as? [MinesweeperTile] {
            grid = shuffled
        }
        return MinesweeperGrid(
            width: configuration.width,
            height: configuration.height,
            grid: grid
        )
    }
}

struct MinesweeperGrid {

    struct Point: Hashable, Equatable {
        let x: Int
        let y: Int
    }

    typealias Tile = MinesweeperTile

    let width: Int
    let height: Int
    private var grid: [Tile]
    private(set) var isGameOver: Bool

    fileprivate init(width: Int, height: Int, grid: [Tile]) {
        self.width = width
        self.height = height
        self.grid = grid
        self.isGameOver = false
    }

    subscript(x: Int, y: Int) -> Tile {
        get {
            grid[y * width + x]
        }
        set(newValue) {
            grid[y * width + x] = newValue
        }
    }

    /// Checks whether a point is within the grid.
    private func isInBounds(x: Int, y: Int) -> Bool {
        return x >= 0 && x < width &&
               y >= 0 && y < height
    }

    /// Gets the points directly adjacent to a point.
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

    /// Gets the tiles directly adjacent to a point.
    func adjacentTiles(x: Int, y: Int) -> [Tile] {
        adjacentPoints(x: x, y: y)
            .map { point in
                self[point.x, point.y]
            }
    }

    /// Gets the total number of mines that are adjacent to a point.
    func mineCount(x: Int, y: Int) -> Int {
        adjacentTiles(x: x, y: y)
            .filter { tile in
                tile.content == .mine
            }
            .count
    }

    /// Recursively finds all the points that are zero which are connected to the given point.
    private func findZeroesConnectedTo(x: Int, y: Int, newSet: Set<Point> = Set()) -> Set<Point> {
        var set = newSet
        for point in adjacentPoints(x: x, y: y) {
            if mineCount(x: point.x, y: point.y) == 0 && self[point.x, point.y].content != .mine {
                if !set.contains(point) {
                    set.insert(point)
                    set = set.union(findZeroesConnectedTo(x: point.x, y: point.y, newSet: set))
                }
            }
        }
        return set
    }

    /// Exposes all adjacent points to the given point that are zero, and then repeats the process for those points.
    private mutating func markSweep(x: Int, y: Int) {
        let zeroes = findZeroesConnectedTo(x: x, y: y, newSet:Set<Point>())
        // We make a copy of the grid here to operate on, so we can freely mutate it and update ourselves only once.
        var newGrid = self
        for point in zeroes {
            newGrid[point.x, point.y].state = .exposed
            for point in adjacentPoints(x: point.x, y: point.y) {
                newGrid[point.x, point.y].state = .exposed
            }
        }
        // Replace the contents of `self` with the updated grid.
        self = newGrid
    }
    
    mutating func selectTile(x: Int, y: Int) {
        self[x, y].state = .exposed
        let tile = self[x,y]

        if tile.content == .mine {
            print("BOOM! Game over.")
            exposeAllMines()
            self[x, y].state = .exposedMine
            isGameOver = true
        } else if mineCount(x: x, y: y) == 0 {
            markSweep(x: x, y: y)
        }
    }

    private mutating func exposeAllMines() {
        grid = grid.map { tile in
            if tile.content == .mine {
                var updatedTile = tile
                updatedTile.state = .exposed
                return updatedTile
            } else {
                return tile
            }
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
        case exposedMine
    }

    enum Content {
        case mine
        case empty
    }
}
