//
//  AboutView.swift
//  Minesweeper
//
//  Created by Kalle Pronk on 27/01/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("We are Kalle & Mathijs. As a passion project we wanted to make a dedicated minesweeper app for apple devices. As a way to learn more about app making, and to make a free game that doesn't bombard users with advertisements. We hope you enjoy our app!")
                Divider()
                Text("Q42 b.v.")
                Q42()
                    .foregroundColor(.q42Green)
                    .frame(height: 100)
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AboutView()
        }
    }
}
