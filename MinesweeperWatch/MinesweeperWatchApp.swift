//
//  MinesweeperWatchApp.swift
//  MinesweeperWatch
//
//  Created by Mathijs Bernson on 26/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import SwiftUI

@main
struct MinesweeperWatchApp: App {
    let gridFactory: GridFactory
    @State var grid: MinesweeperGrid

    init() {
        let gridFactory = RandomGridFactory()
        let config = GameConfiguration.default
        let grid = gridFactory.makeGrid(for: config)
        self.gridFactory = gridFactory
        self._grid = .init(initialValue: grid)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(grid: $grid)
        }
    }

    func newGame(for configuraton: GameConfiguration) {
        grid = gridFactory.makeGrid(for: configuraton)
    }
}
