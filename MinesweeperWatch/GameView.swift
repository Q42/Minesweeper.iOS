//
//  GameView.swift
//  MinesweeperWatch Watch App
//
//  Created by Mathijs Bernson on 26/11/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @Binding var grid: MinesweeperGrid
    @Binding var state: MinesweeperState?
    let playAgain: () -> Void

    @State private var flagMode: Bool = false
    @State private var scale: CGFloat = 1.0

    @FocusState private var isGridFocused
    @ScaledMetric private var tileSize: CGFloat = 40
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Toggle("Flag", isOn: $flagMode)

            let width = tileSize * CGFloat(grid.width)
            let height = tileSize * CGFloat(grid.height)
            ScrollView([.horizontal, .vertical]) {
                GridView(grid: $grid, state: $state, flagMode: flagMode)
                    .scaleEffect(x: scale, y: scale)
                    .frame(width: width * scale, height: height * scale)
                    .focusable()
                    .focused($isGridFocused)
            }
            .digitalCrownRotation($scale, from: 0.75, through: 1.5, sensitivity: .low)
            .ignoresSafeArea(edges: [.bottom, .horizontal])
            .onAppear { isGridFocused = true }
        }
        .fullScreenCover(item: $state) { state in
            switch state {
            case .won:
                GameWonView(playAgain: playAgain)
            case .gameOver:
                GameOverView(playAgain: playAgain)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static let factory = RandomGridFactory()
    @State static var grid = factory.makeGrid(for: .beginner)
    @State static var state: MinesweeperState?

    static var previews: some View {
        GameView(grid: $grid, state: $state, playAgain: {})
    }
}
