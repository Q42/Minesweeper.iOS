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
    @State var state: MinesweeperState?
    @State var isPresentingGame: Bool = false
    @State var isPresentingCustomGameSheet: Bool = false

    init() {
        gridFactory = RandomGridFactory()
        let grid = gridFactory.makeGrid(for: GameConfiguration.default)
        self._grid = .init(initialValue: grid)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section("New game") {
                        Button("Beginner") {
                            newGame(for: .beginner)
                        }
                        Button("Intermediate") {
                            newGame(for: .intermediate)
                        }
                        Button("Expert") {
                            newGame(for: .expert)
                        }
                        Button("Custom") {
                            isPresentingCustomGameSheet = true
                        }
                    }
                }
                .sheet(isPresented: $isPresentingCustomGameSheet) {
                    NavigationStack {
                        CustomGameForm { configuration in
                            isPresentingCustomGameSheet = false
                            newGame(for: configuration)
                        }
                        .navigationTitle("Custom game")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .navigationDestination(isPresented: $isPresentingGame) {
                    GameView(grid: $grid, state: $state, playAgain: { clearState() })
                }
            }
        }
    }

    func newGame(for configuraton: GameConfiguration) {
        grid = gridFactory.makeGrid(for: configuraton)
        isPresentingGame = true
        state = nil
    }

    func clearState() {
        isPresentingGame = false
        state = nil
    }
}
