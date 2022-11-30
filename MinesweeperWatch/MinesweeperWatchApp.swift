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

    init() {
        gridFactory = RandomGridFactory()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section("New game") {
                        NavigationLink("Beginner", value: GameConfiguration.beginner)
                        NavigationLink("Intermediate", value: GameConfiguration.intermediate)
                        NavigationLink("Expert", value: GameConfiguration.expert)
                    }
                }
                .navigationDestination(for: GameConfiguration.self) { configuration in
                    GameView(grid: gridFactory.makeGrid(for: configuration))
                }
            }
        }
    }
}
