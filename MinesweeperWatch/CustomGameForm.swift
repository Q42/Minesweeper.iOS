//
//  CustomGameForm.swift
//  MinesweeperWatch
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
            Section("Board width") {
                Stepper("\(width)", value: $width, in: 3...50)
            }

            Section("Board height") {
                Stepper("\(height)", value: $height, in: 3...50)
            }

            Section("Mines") {
                Stepper("\(minesCount)", value: $minesCount, in: 1...(width * height))
            }

            Button("Start game") {
                let configuration = GameConfiguration.custom(
                    width: width, height: height, minesCount: minesCount
                )
                completion(configuration)
            }
        }
    }
}

struct CustomGameForm_Previews: PreviewProvider {
    static var previews: some View {
        CustomGameForm() { _ in }
    }
}
