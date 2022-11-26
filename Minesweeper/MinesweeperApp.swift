//
//  MinesweeperApp.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

@main
struct MinesweeperApp: App {
    let gridFactory: GridFactory
    @State var grid: MinesweeperGrid

    init() {
        let gridFactory = SeededRandomGridFactory()
        let config = GameConfiguration.default
        let grid = gridFactory.makeGrid(for: config)
        self.gridFactory = gridFactory
        self._grid = .init(initialValue: grid)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GameView(grid: $grid)
            }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Menu("New game") {
                    Button("Beginner") {
                        newGame(for: .beginner)
                    }
                    Button("Intermediate") {
                        newGame(for: .intermediate)
                    }
                    Button("Expert") {
                        newGame(for: .expert)
                    }
                }
            }
        }
    }

    func newGame(for configuraton: GameConfiguration) {
        grid = gridFactory.makeGrid(for: configuraton)
    }
}
