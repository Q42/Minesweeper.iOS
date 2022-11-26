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
    @ScaledMetric private var tileSize: CGFloat = 44
    
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

struct ContentView_Previews: PreviewProvider {
    static let factory = SeededRandomGridFactory(seed: "hakvoort!".data(using: .utf8))
    @State static var grid = factory.makeGrid(for: .beginner)

    static var previews: some View {
        ContentView(grid: $grid)
    }
}
