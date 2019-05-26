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
    var lastPoint = CGPoint(x: -1, y: -1)
    var lastDirection = ""
    override func touchUp(row: Int, col: Int, tileMap: SKTileMapNode, unitMap: SKTileMapNode) {
        super.touchUp(row: row, col: col, tileMap: tileMap, unitMap: unitMap)
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
        
        unitMap.setTileGroup(duckTile, forColumn: col, row: row)
        TileData.shared.tiles[row][col] = 2
        TileData.shared.startPoint = CGPoint(x: col, y: row)
        return
    }

    override func showCompleted(unitMap: SKTileMapNode) {
        if TileData.shared.paths.count <= 0 {
            return
        }
        
        guard let objectTileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        let point = TileData.shared.paths.removeFirst()
        self.lastPoint = point
        var direction = "duck-right"
        if TileData.shared.paths.count > 0 {
            let nextPoint = TileData.shared.paths.first
            if point.x > nextPoint!.x {
                direction = "duck-left"
            }
            else if point.x < nextPoint!.x {
                direction = "duck-right"
            }
            else if point.y > nextPoint!.y {
                direction = "duck-down"
            }
            else if point.y < nextPoint!.y {
                direction = "duck-up"
            }

            self.lastDirection = direction
        }
        else {
            direction = self.lastDirection
        }
        
        let objectTileGroups = objectTileSet.tileGroups
        guard let rules = objectTileGroups.first?.rules else {
            fatalError("No Duck tile definition found")
        }

        guard let duckTile = objectTileGroups.first(where: {$0.name == "duck"}) else {
            fatalError("No Duck tile definition found")
        }
        
        for rule in rules {
            for tile in rule.tileDefinitions {
                if tile.name == direction {
                    unitMap.setTileGroup(duckTile, andTileDefinition: tile, forColumn: Int(point.x), row: Int(point.y))
                    break
                }
            }
        }
        
        print("show \(point)")
        return
        
    }

}
