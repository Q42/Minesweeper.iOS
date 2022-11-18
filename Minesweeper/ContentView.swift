//
//  ContentView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
    }
}

struct GameView: View {
    @State var grid: MinesweeperGrid
    let factory: GridFactory
    @State var scale: CGFloat = 1.0
    private let tileSize: CGFloat = 44

    init(factory: GridFactory = .init()) {
        grid = factory.makeGrid(for: .default)
        self.factory = factory
    }

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid)
                .frame(width: tileSize * CGFloat(grid.width), height: tileSize * CGFloat(grid.height))
                .scaleEffect(x: scale, y: scale)
                .frame(width: tileSize * CGFloat(grid.width) * scale, height: tileSize * CGFloat(grid.height) * scale)
        }
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    print(value)
                    scale = value
                }
        )
    }

    func newGrid() {
        grid = factory.makeGrid(for: .default)
    }
}

struct GridView: View {
    @Binding var grid: MinesweeperGrid

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<grid.width, id: \.self) { x in
                        TileView(tile: grid[x, y])
                    }
                }
            }
        }
    }
}

struct TileView: View {
    let tile: MinesweeperTile

    var body: some View {
        Rectangle()
            .fill(.clear)
            .border(.black, width: 1)
            .overlay {
                switch tile.content {
                case .mine:
                    Text("💣")
                case .empty:
                    EmptyView()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
