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

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                GridRow {
                    ForEach(0..<grid.width, id: \.self) { x in
                        Button("Tile \(x) \(y)") {
                            grid.selectTile(x: x, y: y)
                        }
                        .buttonStyle(TileButtonStyle(tile: grid[x, y], mineCount: grid.mineCount(x: x, y: y)))
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Grid")
        .background(.gray)
        .font(.title)
    }
}

private struct TileButtonStyle: ButtonStyle {
    let tile: MinesweeperTile
    let mineCount: Int

    private func imageName(isPressed: Bool) -> String {
        switch tile.state {
        case .hidden:
            if isPressed {
                return "Uncovered"
            } else {
                return "Covered"
            }
        case .exposed:
            switch tile.content {
            case .mine:
                return "Mine"
            case .empty:
                if mineCount == 0 {
                    return "Uncovered"
                } else {
                    return String(mineCount)
                }
            }
        case .exposedMine:
            switch tile.content {
            case .mine:
                return "MineClicked"
            case .empty:
                return "Uncovered"
            }
        case .flagged:
            return "Flag"
        case .questionMark:
            return "Questionmark"
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        Rectangle()
            .fill(.gray)
            .overlay {
                Image(imageName(isPressed: configuration.isPressed))
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

    static var previews: some View {
        GridView(grid: $grid)
    }
}
