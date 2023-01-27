//
//  GameView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 18/11/2022.
//

import SwiftUI

struct GameView: View {
    @Binding var grid: MinesweeperGrid
    @Binding var isGameOver: Bool
    @State private var scale: CGFloat = 1.0
    @ScaledMetric private var tileSize: CGFloat = 44
    @Environment(\.dismiss) var dismiss
    let scaleRange: ClosedRange<CGFloat> = 0.5...3.0
    
    var body: some View {
        let width = tileSize * CGFloat(grid.width)
        let height = tileSize * CGFloat(grid.height)
        
        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid, isGameOver: $isGameOver)
                .disabled(isGameOver)
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
                    guard scaleRange.contains(value) else { return }
                    scale = value
                }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button{} label: {
                        Label("Restart", systemImage: "restart")
                    }
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Label("Back to main menu", systemImage: "xmark.circle")
                    }
                    
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static let factory = SeededRandomGridFactory(seed: "hakvoort!".data(using: .utf8))
    @State static var grid = factory.makeGrid(for: .beginner)
    @State static var isGameOver = false
    
    static var previews: some View {
        NavigationStack {
            GameView(grid: $grid, isGameOver: $isGameOver)
        }
    }
}
