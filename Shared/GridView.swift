//
//  GridView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 26/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import SwiftUI

struct GridView: View {
    @Binding var grid: MinesweeperGrid
    @Binding var state: MinesweeperState
    @Binding var flagMode: Bool

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                GridRow {
                    ForEach(0..<grid.width, id: \.self) { x in
                        let tile = grid[x, y]
                        let mineCount = grid.mineCount(x: x, y: y)
                        let tileDescription = TileDescription(tile, mineCount: mineCount, isPressed: false)

                        Button(tileDescription.localizedDescription) {
                            selectTile(x: x, y: y)
                        }
                        .buttonStyle(TileButtonStyle(tile: tile, imageName: tileDescription.imageName, mineCount: mineCount))
                        .accessibilityLabel(tileDescription.localizedDescription)
                        .accessibilityIdentifier("Tile (\(x),\(y))")
                        .accessibilityAction(named: Text("Plaats vlaggen")){
                            flagMode = true
                            selectTile(x: x, y:y)
                        }
                        .accessibilityAction(named: Text("Verwijder tegel")) {
                            flagMode = false
                            selectTile(x: x, y: y)
                        }
                        
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Grid")
        .background(Color("darkGray"))
        .font(.title)
    }
    
    func selectTile(x: Int, y: Int) {
        // Can't tap when the game is already over
        guard grid.state == .running else { return }

        // Perform the user's action
        if flagMode {
            grid.flagTile(x: x, y: y)
        } else {
            grid.selectTile(x: x, y: y)
        }

        // Update the game state (won/lost)
        state = grid.state
    }
    
    func flagTile() {
        // Can't tap when the game is already over
        guard grid.state == .running else { return }
    }
}

private struct TileButtonStyle: ButtonStyle {
    let tile: MinesweeperTile
    let imageName: String
    let mineCount: Int

    func makeBody(configuration: Configuration) -> some View {
        Rectangle()
            .fill(Color("lightGray"))
            .overlay {
                Image(imageName)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            }
    }
}

struct GridView_Previews: PreviewProvider {
    #if os(iOS) || os(macOS)
    static let factory = SeededRandomGridFactory(seed: "hakvoort!".data(using: .utf8))
    #else
    static let factory = RandomGridFactory()
    #endif

    @State static var grid = factory.makeGrid(for: .beginner)
    @State static var state: MinesweeperState = .running
    @State static var flagMode: Bool = false
    static let tileSize: CGFloat = 30

    static var previews: some View {
        GridView(grid: $grid, state: $state, flagMode: $flagMode)
            .frame(width: tileSize * CGFloat(grid.width), height: tileSize * CGFloat(grid.height))
    }
}
