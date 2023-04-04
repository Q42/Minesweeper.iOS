//
//  SpriteSet.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 13/02/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import Foundation

protocol SpriteSet {
    /// Name of the image from the asset catalog that reflects the tile description
    func imageName(for tileDescription: TileDescription) -> String
}

struct AssetCatalogSpriteSet: SpriteSet, Equatable {
    let name: String
    var previewImageNames: [String] {
        ["Covered", "1", "2", "3", "Mine", "Flag"]
            .map { "\(name)/\($0)" }
    }

    init(_ name: String) {
        self.name = name
    }

    func imageName(for tileDescription: TileDescription) -> String {
        let imageName = nonPrefixedImageName(for: tileDescription)
        return "\(name)/\(imageName)"
    }

    private func nonPrefixedImageName(for tileDescription: TileDescription) -> String {
        switch tileDescription {
        case .covered:
            return "Covered"
        case .uncoveredEmpty:
            return "Uncovered"
        case .uncovered(let mineCount):
            return String(mineCount)
        case .uncoveredMine:
            return "MineClicked"
        case .mine:
            return "Mine"
        case .flag:
            return "Flag"
        case .questionMark:
            return "Questionmark"
        }
    }
}

extension AssetCatalogSpriteSet: Identifiable {
    var id: String { name }
}

extension AssetCatalogSpriteSet {
    static let `default` = AssetCatalogSpriteSet("Modern")

    /// All supported image sets in the app
    static let all: [AssetCatalogSpriteSet] = [
        // The default one should come first
        AssetCatalogSpriteSet("Modern"),
        AssetCatalogSpriteSet("Classic"),
        AssetCatalogSpriteSet("Modern Green"),
        AssetCatalogSpriteSet("Modern Dark"),
    ]
}
