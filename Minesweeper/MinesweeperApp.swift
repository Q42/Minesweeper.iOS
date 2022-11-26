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
        let seed = UserDefaults.standard.string(forKey: "seed")
        if let seed {
            print("Using seed: \(seed)")
        }
        let gridFactory = SeededRandomGridFactory(seed: seed?.data(using: .utf8))
        let config = GameConfiguration.default
        let grid = gridFactory.makeGrid(for: config)
        self.gridFactory = gridFactory
        self._grid = .init(initialValue: grid)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(grid: $grid)
                    .navigationTitle("Minesweeper")
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
