//
//  StatusView.swift
//  Minesweeper
//
//  Created by Kalle Pronk on 24/03/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI

struct StatusView: View {
    let state: MinesweeperState
    let grid: MinesweeperGrid
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var time: Duration = .zero
    
    var body: some View {
        HStack{
            Image("custom.mine.fill")
            Text("\(grid.totalMineTileCount-grid.totalFlaggedTileCount)")
            Text(" - ")
            Image(systemName: "timer")
            Text("\(time.formatted(.time(pattern: .minuteSecond)))")
                .monospacedDigit()
        }
        .monospacedDigit()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(grid.totalMineTileCount-grid.totalFlaggedTileCount), Mines remaining, you have been playing for \(time.description)")
        .onReceive(timer) { _ in
            if state == .running {
                time += .seconds(1)
            }
        }
    }
}

//struct StatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatusView(grid: .example)
//    }
//}
