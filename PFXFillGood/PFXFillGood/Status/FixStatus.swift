//
//  FixStatus.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import SpriteKit

class FixStatus: GameStatus {
    override func touchUp(row: Int, col: Int, tileMap: SKTileMapNode, unitMap: SKTileMapNode, arrowMap: SKTileMapNode) {
        super.touchUp(row: row, col: col, tileMap: tileMap, unitMap: unitMap, arrowMap: arrowMap)
        if col >= TileData.shared.col || row >= TileData.shared.row {
            print("over tile")
            return
        }
        
        guard let tileSet = SKTileSet(named: "Ground Tiles") else {
            fatalError("Tile Set not found")
        }
        
        let tileGroups = tileSet.tileGroups
        guard let grassTile = tileGroups.first(where: {$0.name == "Grass Tile"}) else {
            fatalError("Grass Tile definition found")
        }
        
        guard let waterTile = tileGroups.first(where: {$0.name == "Water Tile"}) else {
            fatalError("Water Tile definition found")
        }
        
        let tile = tileMap.tileDefinition(atColumn: col, row: row)
        if tile?.name == "GrassCenter1" {
            tileMap.setTileGroup(waterTile, forColumn: col, row: row)
            TileData.shared.tiles[row][col] = 0
        }
        else {
            tileMap.setTileGroup(grassTile, forColumn: col, row: row)
            TileData.shared.tiles[row][col] = 1
        }
        
        return
    }
}
