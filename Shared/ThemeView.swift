//
//  ThemeView.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 24/03/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    @Binding var selectedTheme: AssetCatalogSpriteSet
    let themes = AssetCatalogSpriteSet.all

    var body: some View {
        List {
            ForEach(themes) { theme in
                Button {
                    selectedTheme = theme
                } label: {
                    HStack {
                        Image(systemName: theme == selectedTheme ? "checkmark" : "")
                            .frame(width: 44, height: 44, alignment: .center)

                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .foregroundColor(.primary)
                            HStack {
                                ForEach(theme.previewImageNames, id: \.self) { previewImage in
                                    Image(previewImage)
                                        .interpolation(.none)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .navigationTitle("Themes")
    }
}

struct ThemeView_Previews: PreviewProvider {
    @State static var spriteSet = AssetCatalogSpriteSet.default
    static var previews: some View {
        NavigationStack {
            ThemeView(selectedTheme: $spriteSet)
        }
    }
}
