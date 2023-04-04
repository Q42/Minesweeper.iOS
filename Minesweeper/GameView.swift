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
    @State var flagMode: Bool = false
    @State var isPresentingGameOverSheet = false
    
    var body: some View {
        let width = tileSize * CGFloat(grid.width)
        let height = tileSize * CGFloat(grid.height)

        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid, state: $state, spriteSet: spriteSet, flagMode: $flagMode)
                .frame(width: width, height: height)
                .scaleEffect(x: scale, y: scale)
                .frame(width: width * scale, height: height * scale)
                .padding(40)
        }
        .ignoresSafeArea(edges: .bottom)
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
            ToolbarItem {
                let flagButtonLabel = flagMode ? String(localized: "Remove Flag") : String(localized: "Flag")
                Button {
                    flagMode.toggle()
                } label: {
                    let flagButtonImage = flagMode ? "flag.slash.circle" : "flag.circle"
                    Label(flagButtonLabel, systemImage: flagButtonImage)
                }
                .accessibilityIdentifier(flagButtonLabel)
                .accessibilityLabel(flagButtonLabel)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("GameView")
    }
}

struct GameView_Previews: PreviewProvider {
    static let factory = SeededRandomGridFactory(seed: "hakvoort!".data(using: .utf8))
    @State static var grid = factory.makeGrid(for: .beginner)
    @State static var state: MinesweeperState = .running
    
    static var previews: some View {
        NavigationStack {
            GameView(grid: $grid, state: $state, playAgain: {}, spriteSet: .default) 
        }
    }
}
