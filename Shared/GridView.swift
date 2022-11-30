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
                        let tile = grid[x, y]
                        let mineCount = grid.mineCount(x: x, y: y)
                        let tileDescription = descriptionForTile(tile, mineCount: mineCount, isPressed: false).localizedDescription

                        Button(tileDescription) {
                            grid.selectTile(x: x, y: y)
                        }
                        .buttonStyle(TileButtonStyle(tile: tile, mineCount: mineCount))
                        .accessibilityLabel(tileDescription)
                        .accessibilityIdentifier("Tile (\(x),\(y))")
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

enum TileDescription {
    case covered
    case uncoveredEmpty
    case uncoveredMine
    case mine
    case uncovered(mineCount: Int)
    case flag
    case questionMark

    var imageName: String {
        switch self {
        case .covered:
            return "Covered"
        case .uncoveredEmpty:
            return "Uncovered"
        case .uncovered(let mineCount):
            return String(mineCount)
        case .uncoveredMine:
            return "MineClicked"
        case .mine:
            return "Mine"
        case .flag:
            return "Flag"
        case .questionMark:
            return "QuestionMark"
        }
    }

    var localizedDescription: String {
        switch self {
        case .covered:
            return String(localized: "Covered")
        case .uncoveredEmpty:
            return String(localized: "Empty")
        case .uncoveredMine:
            return String(localized: "Uncovered mine")
        case .mine:
            return String(localized: "Mine")
        case .uncovered(let mineCount):
            return String(localized: "\(mineCount) mines nearby")
        case .flag:
            return String(localized: "Flagged")
        case .questionMark:
            return String(localized: "Question mark")
        }
    }
}

private struct TileButtonStyle: ButtonStyle {
    let tile: MinesweeperTile
    let mineCount: Int

    func makeBody(configuration: Configuration) -> some View {
        Rectangle()
            .fill(.gray)
            .overlay {
                Image(descriptionForTile(tile, mineCount: mineCount, isPressed: configuration.isPressed).imageName)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            }
    }
}

private func descriptionForTile(_ tile: MinesweeperTile, mineCount: Int, isPressed: Bool) -> TileDescription {
    switch tile.state {
    case .hidden:
        if isPressed {
            return .uncoveredEmpty
        } else {
            return .covered
        }
    case .exposed:
        switch tile.content {
        case .mine:
            return .mine
        case .empty:
            if mineCount == 0 {
                return .uncoveredEmpty
            } else {
                return .uncovered(mineCount: mineCount)
            }
        }
    case .exposedMine:
        switch tile.content {
        case .mine:
            return .uncoveredMine
        case .empty:
            return .uncoveredEmpty
        }
    case .flagged:
        return .flag
    case .questionMark:
        return .questionMark
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
