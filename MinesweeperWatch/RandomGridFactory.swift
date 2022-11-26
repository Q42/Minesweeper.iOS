//
//  RandomGridFactory.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 26/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import Foundation

struct RandomGridFactory: GridFactory {
    func makeGrid(for configuration: GameConfiguration) -> MinesweeperGrid {
        let size = configuration.width * configuration.height
        let emptyCount = size - configuration.minesCount

        let mine = MinesweeperTile(state: .hidden, content: .mine)
        let empty = MinesweeperTile(state: .hidden, content: .empty)

        var grid: [MinesweeperTile] = Array(repeating: mine, count: configuration.minesCount) + Array(repeating: empty, count: emptyCount)
        grid.shuffle()
        return MinesweeperGrid(
            width: configuration.width,
            height: configuration.height,
            grid: grid
        )
    }
}
