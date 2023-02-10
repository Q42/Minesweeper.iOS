//
//  GameView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

struct GameView: View {
    @Binding var grid: MinesweeperGrid
    @Binding var state: MinesweeperState?
    let playAgain: () -> Void

    @State private var scale: CGFloat = 1.0
    @ScaledMetric private var tileSize: CGFloat = 44
    @Environment(\.dismiss) var dismiss
    let scaleRange: ClosedRange<CGFloat> = 0.5...3.0
    @State var flagMode: Bool = false
    @State var time: Duration = .zero
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let width = tileSize * CGFloat(grid.width)
        let height = tileSize * CGFloat(grid.height)

        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid, state: $state, flagMode: flagMode)
                .frame(width: width, height: height)
                .scaleEffect(x: scale, y: scale)
                .frame(width: width * scale, height: height * scale)
        }
        .ignoresSafeArea(edges: .bottom)
        .onReceive(timer) { _ in
            if state == nil {
                time += .seconds(1)
            }
        }
        .sheet(item: $state) { state in
            switch state {
            case .won:
                GameWonView(playAgain: playAgain)
            case .gameOver:
                GameOverView(playAgain: playAgain)
            }
        }
        .navigationTitle("\(grid.totalMineTileCount-grid.totalFlaggedTileCount) - \(time.formatted(.time(pattern: .minuteSecond)))")
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
                    Image(systemName: "gear")
                }
            }
#endif
            ToolbarItem {
                Button {
                    flagMode.toggle()
                } label: {
                    if flagMode{
                        Image(systemName: "flag.slash.circle")
                    }
                    else{
                        Image(systemName: "flag.circle")
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("GameView")
    }
}

struct GameView_Previews: PreviewProvider {
    static let factory = SeededRandomGridFactory(seed: "hakvoort!".data(using: .utf8))
    @State static var grid = factory.makeGrid(for: .beginner)
    @State static var state: MinesweeperState?
    
    static var previews: some View {
        NavigationStack {
            GameView(grid: $grid, state: $state, playAgain: {}) 
        }
    }
}
