//
//  GameEndedView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 27/01/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI

private struct GameEndedView: View {
    let emoji: String
    let title: LocalizedStringKey
    let playAgain: () -> Void

    #if(os(watchOS))
    @ScaledMetric var spacing: CGFloat = 4
    #else
    @ScaledMetric var spacing: CGFloat = 24
    #endif

    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: spacing) {
                    VStack {
                        Text(emoji)
                            .font(.largeTitle)
                        Text(title)
                            .font(.title)
                    }
                    #if(os(watchOS))
                    Button("Play again") {
                        playAgain()
                    }
                    #endif
                    #if(os(iOS))
                    Button("Play again") {
                        playAgain()
                    }
                    #endif
                    Button("View board") {
                        dismiss()
                    }
                    .accessibilityIdentifier("View board")
                }
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .frame(minWidth: 200, minHeight: 200)
    }
}

struct GameOverView: View {
    let playAgain: () -> Void
    var body: some View {
        GameEndedView(emoji: "💣", title: "Game over!", playAgain: playAgain)
    }
}

struct GameWonView: View {
    let playAgain: () -> Void
    var body: some View {
        GameEndedView(emoji: "🎉", title: "You won!", playAgain: playAgain)
    }
}

struct GameEndedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameWonView(playAgain: {})
                .previewDisplayName("Game won")
            GameOverView(playAgain: {})
                .previewDisplayName("Game over")
        }
    }
}
