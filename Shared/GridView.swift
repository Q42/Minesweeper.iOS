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
    @Binding var state: MinesweeperState?
    let flagMode: Bool

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                GridRow {
                    ForEach(0..<grid.width, id: \.self) { x in
                        let tile = grid[x, y]
                        let mineCount = grid.mineCount(x: x, y: y)
                        let tileDescription = TileDescription(tile, mineCount: mineCount, isPressed: false)

                        Button(tileDescription.localizedDescription) {
                            // Can't tap when the game is already over
                            guard grid.state == nil else { return }

                            // Perform the user's action
                            if flagMode {
                                grid.flagTile(x: x, y: y)
                            } else {
                                grid.selectTile(x: x, y: y)
                            }

                            // Update the game state (won/lost)
                            state = grid.state
                        }
                        .buttonStyle(TileButtonStyle(tile: tile, imageName: tileDescription.imageName, mineCount: mineCount))
                        .accessibilityLabel(tileDescription.localizedDescription)
                        .accessibilityIdentifier("Tile (\(x),\(y))")
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Grid")
        .background(Color("darkGray"))
        .font(.title)
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
    @State static var state: MinesweeperState?
    static let tileSize: CGFloat = 30

    static var previews: some View {
        GridView(grid: $grid, state: $state, flagMode: false)
            .frame(width: tileSize * CGFloat(grid.width), height: tileSize * CGFloat(grid.height))
    }
}
