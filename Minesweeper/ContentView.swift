//
//  ContentView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

struct ContentView: View {
    @Binding var grid: MinesweeperGrid
    @State private var scale: CGFloat = 1.0
    private let tileSize: CGFloat = 44
    
    var body: some View {
        let width = tileSize * CGFloat(grid.width)
        let height = tileSize * CGFloat(grid.height)

        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid)
            .disabled(grid.isGameOver)
            .frame(width: width, height: height)
            .scaleEffect(x: scale, y: scale)
            .frame(width: width * scale, height: height * scale)
        }
        #if os(macOS)
        // Set window size
        .frame(
            minWidth: width, idealWidth: width, maxWidth: .infinity,
            minHeight: height, idealHeight: height, maxHeight: .infinity
        )
        #endif
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = value
                }
        )
    }
}

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

struct TileButtonStyle: ButtonStyle {
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

struct ContentView_Previews: PreviewProvider {
    static let factory = RandomGridFactory(seed: "hakvoort!".data(using: .utf8))
    @State static var grid = factory.makeGrid(for: .beginner)

    static var previews: some View {
        ContentView(grid: $grid)
    }
}
