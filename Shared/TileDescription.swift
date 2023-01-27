//
//  TileDescription.swift
//  Minesweeper
//
//  Created by Mathijs Bernson on 27/01/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import Foundation

/// A description of the tile to the user. Derived from the state of the tile.
enum TileDescription {
    case covered
    case uncoveredEmpty
    case uncoveredMine
    case mine
    case uncovered(mineCount: Int)
    case flag
    case questionMark
}

extension TileDescription {
    init(_ tile: MinesweeperTile, mineCount: Int, isPressed: Bool) {
        switch tile.state {
        case .hidden:
            if isPressed {
                self = .uncoveredEmpty
            } else {
                self = .covered
            }
        case .exposed:
            switch tile.content {
            case .mine:
                self = .mine
            case .empty:
                if mineCount == 0 {
                    self = .uncoveredEmpty
                } else {
                    self = .uncovered(mineCount: mineCount)
                }
            }
        case .exposedMine:
            switch tile.content {
            case .mine:
                self = .uncoveredMine
            case .empty:
                self = .uncoveredEmpty
            }
        case .flagged:
            self = .flag
        case .questionMark:
            self = .questionMark
        }
    }

    /// Name of the image from the asset catalog that reflects the tile description
    var imageName: String {
        switch self {
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
            return "QuestionMark"
        }
    }

    /// Localized description of the tile
    var localizedDescription: String {
        switch self {
        case .covered:
            return String(localized: "Covered", comment: "Accessibility description of a tile")
        case .uncoveredEmpty:
            return String(localized: "Empty", comment: "Accessibility description of a tile")
        case .uncoveredMine:
            return String(localized: "Mine", comment: "Accessibility description of a tile")
        case .mine:
            return String(localized: "Mine", comment: "Accessibility description of a tile")
        case .uncovered(let mineCount):
            return String(localized: "\(mineCount) mines nearby", comment: "Accessibility description of a tile")
        case .flag:
            return String(localized: "Flag", comment: "Accessibility description of a tile")
        case .questionMark:
            return String(localized: "Question mark", comment: "Accessibility description of a tile")
        }
    }
}
