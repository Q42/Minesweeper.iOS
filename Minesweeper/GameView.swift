//
//  GameView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

struct GameView: View {
    @Binding var grid: MinesweeperGrid
    @Binding var state: MinesweeperState
    let playAgain: () -> Void

    @State private var scale: CGFloat = 1.0
    @ScaledMetric private var tileSize: CGFloat = 44
    @Environment(\.dismiss) var dismiss
    let scaleRange: ClosedRange<CGFloat> = 0.5...3.0
    let spriteSet: AssetCatalogSpriteSet
    @State var flagMode: FlagMode = .uncoverTile
    @State var isPresentingGameOverSheet = false
    
    var body: some View {
        let width = tileSize * CGFloat(grid.width)
        let height = tileSize * CGFloat(grid.height)

        VStack {
            Picker("Mode", selection: $flagMode) {
                Text("Uncover tile")
                    .tag(FlagMode.uncoverTile)
                Text("Plant flag")
                    .tag(FlagMode.plantFlag)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(.regularMaterial)

            ScrollView([.horizontal, .vertical]) {
                GridView(grid: $grid, state: $state, spriteSet: spriteSet, flagMode: $flagMode)
                    .frame(width: width, height: height)
                    .scaleEffect(x: scale, y: scale)
                    .frame(width: width * scale, height: height * scale)
            }
        }
        .onChange(of: state) { state in
            if state != .running {
                DispatchQueue.main.async {
                    isPresentingGameOverSheet = true
                }
            }
        }
        .sheet(isPresented: $isPresentingGameOverSheet) {
            switch state {
            case .won:
                GameWonView(playAgain: playAgain)
            case .gameOver:
                GameOverView(playAgain: playAgain)
            case .running:
                EmptyView()
            }
        }
#if os(macOS)
        // Set minimum window size
        .frame(
            minWidth: width, maxWidth: .infinity,
            minHeight: height, maxHeight: .infinity
        )
#elseif os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    guard scaleRange.contains(value) else { return }
                    scale = value
                }
        )
#endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                StatusView(state: state, grid: grid)
            }
#if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    // TODO: Implement play again button
//                    Button {
//                        print("TODO")
//                    } label: {
//                        Label("Restart", systemImage: "restart")
//                    }
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Label("Back to main menu", systemImage: "xmark.circle")
                    }
                    
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .accessibilityIdentifier("Back")
                .accessibilityLabel(Text("Back"))
            }
#endif
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("GameView")
    }
}

struct GameView_Preview: View {
    @State var grid: MinesweeperGrid
    @State var state: MinesweeperState = .running
    
    var body: some View {
        NavigationStack {
            GameView(grid: $grid, state: $state, playAgain: {}, spriteSet: .default) 
        }
    }
}

#Preview("Game iOS") {
    let factory = SeededRandomGridFactory(seed: "hakvoort!".data(using: .utf8))
    let grid = factory.makeGrid(for: .expert)
    return GameView_Preview(grid: grid)
}
