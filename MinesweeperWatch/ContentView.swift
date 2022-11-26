//
//  ContentView.swift
//  MinesweeperWatch Watch App
//
//  Created by Mathijs Bernson on 26/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
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
                .frame(width: width * scale, height: height * scale)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static let factory = RandomGridFactory()
    @State static var grid = factory.makeGrid(for: .beginner)

    static var previews: some View {
        ContentView(grid: $grid)
    }
}
