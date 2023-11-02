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
    @State var state: MinesweeperState = .running
    @State var spriteSet: AssetCatalogSpriteSet
    @State var isPresentingGame: Bool = false
    @State var isPresentingCustomGameSheet: Bool = false

    init() {
        let defaultTheme = "Classic Refined"
        UserDefaults.standard.register(defaults: ["theme": defaultTheme])
        let seed = UserDefaults.standard.string(forKey: "seed")
        if let seed {
            print("Game was initialized using a fixed seed: \(seed)")
        }

        let theme = UserDefaults.standard.string(forKey: "theme") ?? defaultTheme
        self._spriteSet = .init(initialValue: AssetCatalogSpriteSet(theme))

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

                    Section("Settings") {
                        NavigationLink("Theme", destination: ThemeView(selectedTheme: $spriteSet))
                    }

                    Section {
                        NavigationLink("How to play", destination: LearnView())
                        NavigationLink("About", destination: AboutView())
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
                    GameView(grid: $grid, state: $state, spriteSet: spriteSet, playAgain: {
                        clearState()
                    })
                }
            }
        }
    }

    func newGame(for configuraton: GameConfiguration) {
        grid = gridFactory.makeGrid(for: configuraton)
        isPresentingGame = true
        state = .running
    }

    func clearState() {
        isPresentingGame = false
        state = .running
    }
}
