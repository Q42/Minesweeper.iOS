//
//  Grid2D.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 14/12/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import Foundation

/// A generic two-dimensional grid of values, with a set of common operations to perform on the points and/or the values.
struct Grid2D<Tile> {
    struct Point: Hashable, Equatable {
        let x: Int
        let y: Int
    }

    let width: Int
    let height: Int
    var memory: [Tile]

    init(width: Int, height: Int, memory: [Tile]) {
        assert(memory.count == width * height, "Incorrect number of tiles given")
        self.width = width
        self.height = height
        self.memory = memory
    }

    init(width: Int, height: Int, valueProvider: (Point) -> Tile) {
        self.width = width
        self.height = height
        self.memory = (0..<height).flatMap { y in
            (0..<width).map { x in
                valueProvider(Point(x: x, y: y))
            }
        }
    }

    subscript(x: Int, y: Int) -> Tile {
        get { memory[y * width + x] }
        set(newValue) { memory[y * width + x] = newValue }
    }

    func point(at index: Int) -> Point {
        Point(x: index % width, y: index / width)
    }

    /// Checks whether a point is within the grid.
    func isInBounds(x: Int, y: Int) -> Bool {
        return x >= 0 && x < width &&
        y >= 0 && y < height
    }

    /// Gets the points directly adjacent to a given point horizontally, vertically and diagonally.
    func adjacentPoints(to point: Point) -> [Point] {
        adjacentPoints(x: point.x, y: point.y)
    }

    /// Gets the points directly adjacent to a given point horizontally, vertically and diagonally.
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
    func adjacentTiles(to point: Point) -> [Tile] {
        adjacentPoints(to: point)
            .map { point in
                self[point.x, point.y]
            }
    }

    /// Gets the tiles directly adjacent to a point.
    func adjacentTiles(x: Int, y: Int) -> [Tile] {
        adjacentPoints(x: x, y: y)
            .map { point in
                self[point.x, point.y]
            }
    }

    /// Returns an array containing the results of mapping the given closure over the grid's points.
    func map<T>(_ transform: (Point) -> T) -> [T] {
        (0..<height).flatMap { y in
            (0..<width).map { x in
                transform(Point(x: x, y: y))
            }
        }
    }

    /// Returns an array containing, in order, the points of the grid that satisfy the given predicate.
    func filter(_ isIncluded: (Point) -> Bool) -> [Point] {
        (0..<height).flatMap { y in
            (0..<width).compactMap { x in
                let point = Point(x: x, y: y)
                return isIncluded(point) ? point : nil
            }
        }
    }
}

func printGrid<Tile>(_ grid: Grid2D<Tile>, formatter: (Tile) -> String) {
    for row in 0..<grid.height {
        let offset = row * grid.width
        print(grid.memory[offset..<(offset + grid.width)].map(formatter).joined(separator: ""))
    }
}
