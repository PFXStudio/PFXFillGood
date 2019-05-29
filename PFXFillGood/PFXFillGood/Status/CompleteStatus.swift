//
//  CompleteStatus.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import SpriteKit

class CompleteStatus: GameStatus {
    var lastPoint = CGPoint(x: -1, y: -1)
    var lastDirection = ""
    var lastArrowName = ""
    var cursorNode : SKShapeNode?
    var cursorNodes: [SKShapeNode]?

    override init() {
        super.init()
        self.cursorNode = SKShapeNode.init(rectOf: CGSize.init(width: 50, height: 50), cornerRadius: 10)
        
        if let cursorNode = self.cursorNode {
            cursorNode.name = "cursor"
            cursorNode.fillColor = UIColor.red
            cursorNode.alpha = 0
        }
    }

    override func touchUp(row: Int, col: Int, tileMap: SKTileMapNode, unitMap: SKTileMapNode, arrowMap: SKTileMapNode) {
        super.touchUp(row: row, col: col, tileMap: tileMap, unitMap: unitMap, arrowMap: arrowMap)

        return
    }
    
    override func showCompleted(scene: SKScene, unitMap: SKTileMapNode, arrowMap: SKTileMapNode) {
        if TileData.shared.paths.count <= 0 {
            return
        }
        
        guard let objectTileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        guard let arrowTileSet = SKTileSet(named: "Arrow Tiles") else {
            fatalError("Arrow Tiles Tile Set not found")
        }
        
        let point = TileData.shared.paths.removeFirst()
        self.lastPoint = point
        var direction = "duck-right"
        var arrowName = "dot-right"
        if TileData.shared.paths.count > 0 {
            let nextPoint = TileData.shared.paths.first
            if point.x > nextPoint!.x {
                direction = "duck-left"
                arrowName = "dot-left"
            }
            else if point.x < nextPoint!.x {
                direction = "duck-right"
                arrowName = "dot-right"
            }
            else if point.y > nextPoint!.y {
                direction = "duck-down"
                arrowName = "dot-down"
            }
            else if point.y < nextPoint!.y {
                direction = "duck-up"
                arrowName = "dot-up"
            }
            
            self.lastDirection = direction
            self.lastArrowName = arrowName
        }
        else {
            direction = self.lastDirection
            arrowName = self.lastArrowName
        }
        
        let objectTileGroups = objectTileSet.tileGroups
        guard let rules = objectTileGroups.first?.rules else {
            fatalError("No Duck tile definition found")
        }
        
        guard let duckTile = objectTileGroups.first(where: {$0.name == "duck"}) else {
            fatalError("No Duck tile definition found")
        }
        
        let arrowTileGroups = arrowTileSet.tileGroups
        guard let arrowRules = arrowTileGroups.first?.rules else {
            fatalError("No arrowRules definition found")
        }
        
        guard let arrowTile = arrowTileGroups.first(where: {$0.name == "arrow"}) else {
            fatalError("No arrowTile definition found")
        }
        
        for rule in rules {
            for tile in rule.tileDefinitions {
                if tile.name == direction {
                    if let n = self.cursorNode?.copy() as! SKShapeNode? {
                        let pos = arrowMap.centerOfTile(atColumn: Int(point.x), row: Int(point.y))
                        n.position = pos
                        scene.addChild(n)
                    }
                    
                    unitMap.setTileGroup(duckTile, andTileDefinition: tile, forColumn: Int(point.x), row: Int(point.y))
                    break
                }
            }
        }
        
        for rule in arrowRules {
            for tile in rule.tileDefinitions {
                if tile.name == arrowName {
                    arrowMap.setTileGroup(arrowTile, andTileDefinition: tile, forColumn: Int(point.x), row: Int(point.y))
                    break
                }
            }
        }
        
        print("show \(point)")
        if TileData.shared.paths.count <= 0 {
            var nodes = [SKNode]()
            scene.enumerateChildNodes(withName: "cursor") { (node, _) in
                nodes.append(node)
            }

            /*
            for i in 0..<nodes.count {
                let alpha = (1.0 / CGFloat(nodes.count)) * CGFloat(i)
                let node = nodes[i]
                node.alpha = alpha
            }
 */
            recursiveEnding(index: 0, nodes: nodes)
            GameStatus.shared = StartStatus()
        }
        
        return
    }
    
    func recursiveEnding(index: Int, nodes: [SKNode]) {
        if index >= nodes.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.recursiveEnding(index: 0, nodes: nodes)
            }
            
            return
        }
        
        let node = nodes[index]
        node.removeAllActions()
        let sequenceActions = SKAction.sequence([SKAction.fadeIn(withDuration: 0.2), SKAction.run({
            self.recursiveEnding(index: index + 1, nodes: nodes)
        }), SKAction.fadeOut(withDuration: 1)])
        
        node.run(sequenceActions)
    }
}
