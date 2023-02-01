//
//  SeededRandomGridFactory.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 26/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import Foundation
import GameKit

/// Grid factory that uses a seeded random number source from Apple's GameKit to generate grids in a deterministic manner if we want it to.
struct SeededRandomGridFactory: GridFactory {
    private let randomSource: GKARC4RandomSource

    var seed: Data { randomSource.seed }

    /// Initialize the factory with a seed, if given. If `nil` is passed, a random one is selected.
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
        let shuffled = randomSource.arrayByShufflingObjects(in: grid) as! [MinesweeperTile]
        grid = shuffled
        return MinesweeperGrid(
            width: configuration.width,
            height: configuration.height,
            memory: grid
        )
    }
}
