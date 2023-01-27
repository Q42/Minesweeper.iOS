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
    @State var flagMode: Bool = false
    
    var body: some View {
        let width = tileSize * CGFloat(grid.width)
        let height = tileSize * CGFloat(grid.height)
        
        ScrollView([.horizontal, .vertical]) {
            GridView(grid: $grid, isGameOver: $isGameOver, flagMode: flagMode)
                .disabled(isGameOver)
                .frame(width: width, height: height)
                .scaleEffect(x: scale, y: scale)
                .frame(width: width * scale, height: height * scale)
        }
#if os(macOS)
        // Set minimum window size
        .frame(
            minWidth: width, maxWidth: .infinity,
            minHeight: height, maxHeight: .infinity
        )
#endif
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    guard scaleRange.contains(value) else { return }
                    scale = value
                }
        )
#if os(iOS)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {

                Menu {
                    Button {
                        print("TODO")
                    } label: {
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
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
#endif
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
