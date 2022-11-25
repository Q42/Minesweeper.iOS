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
            .background(.gray, ignoresSafeAreaEdges: .all)
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
            GridView(grid: $grid) { x, y in
                grid[x, y].state = .exposed
                if grid.mineSelected(x: x, y: y) {
                    print("BOOM!")
                }
                if grid.mineCount(x: x, y: y) == 0 {
                    grid.markSweep(x: x, y: y)
                }
            }
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
    let onSelect: (Int, Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                HStack(spacing: 0) {
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
    }
}

struct TileView: View {
    let tile: MinesweeperTile
    let mineCount: Int
    
    var body: some View {
        Rectangle()
            .fill(.gray)
            .border(.black, width: 1)
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
    static var previews: some View {
        ContentView()
    }
}
