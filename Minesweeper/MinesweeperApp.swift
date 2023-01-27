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
    @State var isPresentingGame: Bool = false
    @State var isPresentingCustomSheet: Bool = false
    @State var isGameOver: Bool = false

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
                GameView(grid: $grid, isGameOver: $isGameOver)
                    .navigationTitle(Text("Minesweeper", comment: "App title bar"))
                    .sheet(isPresented: $isPresentingCustomSheet) {
                        CustomGameForm { configuration in
                            isPresentingCustomSheet = false
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
                            isPresentingCustomSheet = true
                        }
                        .sheet(isPresented: $isPresentingCustomSheet) {
                            NavigationStack {
                                CustomGameForm { configuration in
                                    isPresentingCustomSheet = false
                                    newGame(for: configuration)
                                }
                                .navigationTitle("Custom game")
                                .navigationBarTitleDisplayMode(.inline)
                            }
                        }
                    }
                    NavigationLink("About"){
                        AboutView()
                    }
                }
                .navigationTitle(Text("Minesweeper", comment: "App title bar"))
                .navigationDestination(isPresented: $isPresentingGame) {
                    GameView(grid: $grid, isGameOver: $isGameOver).navigationBarBackButtonHidden()
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
                        isPresentingCustomSheet = true
                    }
                }
            }
        }
    }

    func newGame(for configuraton: GameConfiguration) {
        grid = gridFactory.makeGrid(for: configuraton)
        isPresentingGame = true
        isGameOver = false
    }
}
