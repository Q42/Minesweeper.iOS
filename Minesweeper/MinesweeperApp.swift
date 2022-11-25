//
//  MinesweeperApp.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

@main
struct MinesweeperApp: App {
    let gridFactory = RandomGridFactory()
    let config: GameConfiguration = .custom(width: 30, height: 16, minesCount: 50)

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(grid: gridFactory.makeGrid(for: config))
            }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Menu("New game") {
                    Button("Beginner") {
                        //
                    }
                    Button("Intermediate") {
                        //
                    }
                    Button("Expert") {
                        //
                    }
                }
            }
        }
    }
}
