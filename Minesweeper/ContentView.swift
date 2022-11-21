//
//  ContentView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

struct ContentView: View {
    @State var grid: MinesweeperGrid
    @State var scale: CGFloat = 1.0
    private let tileSize: CGFloat = 44
    
    init(grid: MinesweeperGrid) {
        self.grid = grid
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid) { x, y in
                grid[x, y].state = .exposed
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
                    scale = value
                }
        )
    }
}

struct GridView: View {
    @Binding var grid: MinesweeperGrid
    let onSelect: (Int, Int) -> Void
    let borderWidth: CGFloat = 2
    let borderColor = Color("borderColor")
    
    var body: some View {
        Grid(horizontalSpacing: borderWidth, verticalSpacing: borderWidth) {
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
        .background(borderColor)
        .border(borderColor, width: borderWidth)
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
                    Text("?")
//                        .foregroundColor(.clear)
                case .exposed:
                    switch tile.content {
                    case .mine:
                        Text("💣")
                    case .empty:
                        if mineCount == 0 {
                            EmptyView()
                        } else if mineCount == 1 {
                            Text("\(mineCount)")
                                .bold()
                                .foregroundColor(.blue)
                        } else if mineCount == 2 {
                            Text("\(mineCount)")
                                .bold()
                                .foregroundColor(.green)
                        } else if mineCount == 3 {
                            Text("\(mineCount)")
                                .bold()
                                .foregroundColor(.red)
                        } else {
                            Text("\(mineCount)")
                                .bold()
                                .foregroundColor(.purple)
                        }
                    }
                case .flagged:
                    Text("🚩")
                case .questionMark:
                    Text("?")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let factory = RandomGridFactory(seed: "hakvoort!".data(using: .utf8))

    static var previews: some View {
        ContentView(grid: factory.makeGrid(for: .beginner))
    }
}
