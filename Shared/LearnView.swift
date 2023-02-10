//
//  LearnView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 27/01/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI

struct LearnView: View {
    @ScaledMetric var paragraphSpacing: CGFloat = 16
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: paragraphSpacing) {
                Text("learn.part.1")
                Text("learn.part.2")
                Text("learn.part.3")
                Text("learn.part.4")
                Text("learn.part.5")
            }
            .padding()
            .multilineTextAlignment(.leading)
        }
        .navigationTitle("How to play")
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LearnView()
        }
    }
}
