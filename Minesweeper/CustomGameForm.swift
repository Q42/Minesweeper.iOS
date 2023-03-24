//
//  CustomGameForm.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 27/01/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI

struct CustomGameForm: View {
    let completion: (GameConfiguration) -> Void

    @AppStorage("CustomGameWidth") var width: Int = 15
    @AppStorage("CustomGameHeight") var height: Int = 15
    @AppStorage("CustomGameMinesCount") var minesCount: Int = 5

    var body: some View {
        Form {
            Section("Board") {
                HStack {
                    Text("Width: \(width)")
                    Spacer()
                    Stepper("Width", value: $width, in: 3...50)
                }
                HStack {
                    Text("Height: \(height)")
                    Spacer()
                    Stepper("Height", value: $height, in: 3...50)
                }
            }.labelsHidden()

            Section("Mines") {
                HStack {
                    Text("Mine count: \(minesCount)")
                    Spacer()
                    Stepper("Mine count", value: $minesCount, in: 1...(width * height - 1))
                }
            }.labelsHidden()

            Button("Start game") {
                let configuration = GameConfiguration.custom(
                    width: width, height: height, minesCount: minesCount
                )
                completion(configuration)
            }
        }
    }
}

struct CustomGameView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGameForm() { _ in }
    }
}
