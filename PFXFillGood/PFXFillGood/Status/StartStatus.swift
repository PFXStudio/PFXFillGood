//
//  StartStatus.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import SpriteKit

class StartStatus: GameStatus {
    override func touchUp(row: Int, col: Int, tileMap: SKTileMapNode, unitMap: SKTileMapNode) {
        super.touchUp(row: row, col: col, tileMap: tileMap, unitMap: unitMap)
        if TileData.shared.tiles[row][col] == 0 {
            return
        }
        
        guard let objectTileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        let objectTileGroups = objectTileSet.tileGroups
        guard let duckTile = objectTileGroups.first(where: {$0.name == "Duck"}) else {
            fatalError("No Duck tile definition found")
        }

        if TileData.shared.startPoint.x != -1 {
            unitMap.setTileGroup(nil, forColumn: Int(TileData.shared.startPoint.x), row: Int(TileData.shared.startPoint.y))
        }
        
        unitMap.setTileGroup(duckTile, forColumn: col, row: row)
        TileData.shared.tiles[row][col] = 2
        TileData.shared.startPoint = CGPoint(x: col, y: row)
        return
    }

}
