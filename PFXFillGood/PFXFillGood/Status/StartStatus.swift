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
    override func touchUp(row: Int, col: Int, tileMap: SKTileMapNode, unitMap: SKTileMapNode, arrowMap: SKTileMapNode) {
        super.touchUp(row: row, col: col, tileMap: tileMap, unitMap: unitMap, arrowMap: arrowMap)
        if TileData.shared.tiles[row][col] == 0 {
            return
        }
        
        guard let objectTileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        let objectTileGroups = objectTileSet.tileGroups
        guard let duckTile = objectTileGroups.first(where: {$0.name == "duck"}) else {
            fatalError("No Duck tile definition found")
        }

        if TileData.shared.startPoint.x != -1 {
            unitMap.setTileGroup(nil, forColumn: Int(TileData.shared.startPoint.x), row: Int(TileData.shared.startPoint.y))
            TileData.shared.tiles[Int(TileData.shared.startPoint.y)][Int(TileData.shared.startPoint.x)] = 1
        }
        
        for row in 0..<TileData.shared.row {
            for col in 0..<TileData.shared.col {
                unitMap.setTileGroup(nil, forColumn: col, row: row)
                arrowMap.setTileGroup(nil, forColumn: col, row: row)
            }
        }

        unitMap.setTileGroup(duckTile, forColumn: col, row: row)
        TileData.shared.tiles[row][col] = 2
        TileData.shared.startPoint = CGPoint(x: col, y: row)
        return
    }
}
