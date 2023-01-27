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
    @State var state: MinesweeperState?
    @State var isPresentingGame: Bool = false
    @State var isPresentingCustomGameSheet: Bool = false

    init() {
        let seed = UserDefaults.standard.string(forKey: "seed")
        if let seed {
            print("Game was initialized using a fixed seed: \(seed)")
        }
        let gridFactory = SeededRandomGridFactory(seed: seed?.data(using: .utf8))
        let grid = gridFactory.makeGrid(for: GameConfiguration.default)

        self.gridFactory = gridFactory
        self._grid = .init(initialValue: grid)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                #if os(macOS)
                GameView(grid: $grid, state: $state, playAgain: { clearState() })
                    .navigationTitle(Text("Minesweeper", comment: "App title bar"))
                    .sheet(isPresented: $isPresentingCustomGameSheet) {
                        CustomGameForm { configuration in
                            isPresentingCustomGameSheet = false
                            newGame(for: configuration)
                        }
                        .padding()
                    }
                #else
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
                    }
                }
                .navigationTitle(Text("Minesweeper", comment: "App title bar"))
                .navigationDestination(isPresented: $isPresentingGame) {
                    GameView(grid: $grid, state: $state, playAgain: { clearState() })
                        .navigationBarBackButtonHidden()
                }
                #endif
            }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Menu("New game") {
                    Button("Beginner") {
                        newGame(for: .beginner)
                    }
                    .keyboardShortcut("n", modifiers: .command)
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
