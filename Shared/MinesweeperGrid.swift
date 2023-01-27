//
//  MinesweeperGrid.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import Foundation

/// Configuration object that tells the `GridFactory` the parameters for the grid that it should generate.
struct GameConfiguration: Hashable {
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

/// A type that creates Minesweeper grids. The configuration determines the size and difficulty of the grid.
protocol GridFactory {
    func makeGrid(for configuration: GameConfiguration) -> MinesweeperGrid
}

typealias MinesweeperGrid = Grid2D<MinesweeperTile>

/// Functions of the grid that are specific to the Minesweeper game.
extension Grid2D where Tile == MinesweeperTile {
    /// Determines whether the game is in a won or lost condition.
    /// If the game is not won or lost yet, nil is returned.
    var state: MinesweeperState? {
        // Check lose condition
        let anyMineIsExposed = memory.contains { tile in
            tile.state == .exposedMine
        }
        if anyMineIsExposed {
            return .gameOver
        }

        // Check win condition

        // Check if all mines have a flag
        let mines = memory.filter { tile in
            tile.content == .mine
        }
        let flaggedMines = mines.filter { tile in
            tile.state == .flagged
        }
        let allMinesAreFlagged = mines.count == flaggedMines.count

        // Check if all empty tiles *don't* have a flag
        let emptyTiles = memory.filter { tile in
            tile.content == .empty
        }
        let nonMineTilesDontHaveFlags = emptyTiles.allSatisfy { tile in
            tile.state != .flagged
        }

        if allMinesAreFlagged && nonMineTilesDontHaveFlags {
            return .won
        } else {
            return nil
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
    
    var totalFlaggedTileCount: Int{
        memory.filter{tile in
            tile.state == .flagged
        }.count
    }
    
    var totalMineTileCount: Int{
        memory.filter{tile in
            tile.content == .mine
        }.count
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
        guard self[x,y].state != .flagged && self[x,y].state != .questionMark else {
            return
        }

        self[x, y].state = .exposed
        let tile = self[x,y]

        if tile.content == .mine {
            print("BOOM! Game over.")
            exposeAllMines()
            self[x, y].state = .exposedMine
        } else if mineCount(x: x, y: y) == 0 {
            markSweep(x: x, y: y)
        }
    }
    
    mutating func flagTile(x: Int, y: Int) {
        if self[x, y].state == .hidden{
            self[x, y].state = .flagged
        }
        else if self[x,y].state == .flagged{
            self[x,y].state = .questionMark
        }
        else {
            self[x,y].state = .hidden
        }
    }

    private mutating func exposeAllMines() {
        memory = memory.map { tile in
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

enum MinesweeperState: Int, Identifiable {
    case won, gameOver
    var id: Int { rawValue }
}
