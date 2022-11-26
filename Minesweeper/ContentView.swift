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
            GridView(grid: $grid) { x, y in
                grid[x, y].state = .exposed
                if grid.mineSelected(x: x, y: y) {
                    print("BOOM!")
                }
                if grid.mineCount(x: x, y: y) == 0 {
                    grid.markSweep(x: x, y: y)
                }
            }
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
    let onSelect: (Int, Int) -> Void
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                GridRow {
                    ForEach(0..<grid.width, id: \.self) { x in
                        Button {
                            onSelect(x, y)
                        } label: {
                            TileView(tile: grid[x, y], mineCount: grid.mineCount(x: x, y: y))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .font(.title)
    }
}

struct TileView: View {
    let tile: MinesweeperTile
    let mineCount: Int
    
    var body: some View {
        Rectangle()
            .fill(.gray)
            .overlay {
                switch tile.state {
                case .hidden:
                    Image("Covered").interpolation(.none).resizable().ignoresSafeArea().scaledToFit()
                case .exposed:
                    switch tile.content {
                    case .mine:
                        Image("Bomb").interpolation(.none).resizable().ignoresSafeArea().scaledToFit()
                    case .empty:
                        if mineCount == 0 {
                            Image("Uncovered").interpolation(.none).resizable().ignoresSafeArea().scaledToFit()
                        } else {
                            Image(String(mineCount)).interpolation(.none).resizable().ignoresSafeArea().scaledToFit()
                        }
                    }
                case .flagged:
                    Image("Flag")
                case .questionMark:
                    Image("Questionmark")
                }
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
