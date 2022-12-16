//
//  GameView.swift
//  MinesweeperWatch Watch App
//
//  Created by Mathijs Bernson on 26/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @State var grid: MinesweeperGrid
    @State var isGameOver: Bool = false
    @State private var scale: CGFloat = 1.0
    @FocusState private var isGridFocused
    @ScaledMetric private var tileSize: CGFloat = 40

    var body: some View {
        let width = tileSize * CGFloat(grid.width)
        let height = tileSize * CGFloat(grid.height)

        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid, isGameOver: $isGameOver)
                .disabled(isGameOver)
                .scaleEffect(x: scale, y: scale)
                .frame(width: width * scale, height: height * scale)
                .focusable()
                .focused($isGridFocused)
        }
        .digitalCrownRotation($scale, from: 0.75, through: 1.5, sensitivity: .low)
        .ignoresSafeArea(edges: [.bottom, .horizontal])
        .onAppear { isGridFocused = true }
    }
}

struct GameView_Previews: PreviewProvider {
    static let factory = RandomGridFactory()

    static var previews: some View {
        GameView(grid: factory.makeGrid(for: .beginner))
    }
}
