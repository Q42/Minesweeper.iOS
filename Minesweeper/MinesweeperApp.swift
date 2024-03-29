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
        let gridFactory = SeededRandomGridFactory(seed: seed?.data(using: .utf8))
        let grid = gridFactory.makeGrid(for: GameConfiguration.default)

        self.gridFactory = gridFactory
        self._grid = .init(initialValue: grid)

        let theme = UserDefaults.standard.string(forKey: "theme") ?? defaultTheme
        self._spriteSet = .init(initialValue: AssetCatalogSpriteSet(theme))
    }

    var body: some Scene {
        WindowGroup {
#if os(macOS)
            GameView(grid: $grid, state: $state, playAgain: { clearState() }, spriteSet: spriteSet)
                .navigationTitle(Text("Minesweeper", comment: "App title bar"))
                .sheet(isPresented: $isPresentingCustomGameSheet) {
                    CustomGameForm { configuration in
                        isPresentingCustomGameSheet = false
                        newGame(for: configuration)
                    }
                    .padding()
                }
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("GameWindow")
#else
            NavigationStack {
                List {
                    Section("New game") {
                        Button("Beginner") {
                            newGame(for: .beginner)
                        }
                        .accessibilityIdentifier("Beginner")
                        Button("Intermediate") {
                            newGame(for: .intermediate)
                        }
                        .accessibilityIdentifier("Intermediate")
                        Button("Expert") {
                            newGame(for: .expert)
                        }
                        .accessibilityIdentifier("Expert")
                        Button("Custom") {
                            isPresentingCustomGameSheet = true
                        }
                        .accessibilityIdentifier("Custom")
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

                    Section("Settings") {
                        NavigationLink("Theme", destination: ThemeView(selectedTheme: $spriteSet))
                    }

                    Section("Info") {
                        NavigationLink("How to play", destination: LearnView())
                        NavigationLink("About", destination: AboutView())
                    }
                }
                .navigationTitle(Text("Minesweeper", comment: "App title bar"))
                .navigationDestination(isPresented: $isPresentingGame) {
                    GameView(grid: $grid, state: $state, playAgain: { clearState() }, spriteSet: spriteSet)
                        .navigationBarBackButtonHidden()
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("GameWindow")
#endif
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Menu("New game") {
                    Button("Beginner") {
                        newGame(for: .beginner)
                    }
                    .accessibilityIdentifier("Beginner")
                    .keyboardShortcut("n", modifiers: .command)
                    Button("Intermediate") {
                        newGame(for: .intermediate)
                    }
                    .accessibilityIdentifier("intermediate")
                    Button("Expert") {
                        newGame(for: .expert)
                    }
                    .accessibilityIdentifier("Expert")
                    Button("Custom") {
                        isPresentingCustomGameSheet = true
                    }
                    .accessibilityIdentifier("Custom")
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
