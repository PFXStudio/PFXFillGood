//
//  GameScene.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 25..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var tileMap:SKTileMapNode!
    var unitMap:SKTileMapNode!

    override func sceneDidLoad() {

        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        guard let width = self.view?.frame.width else {
            return
        }
        
        let size = CGSize(width: width / 7, height: width / 7)
        guard let groundTileSet = SKTileSet(named: "Ground Tiles") else {
            fatalError("groundTileSet not found")
        }
        
        guard let objectTileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        self.tileMap = SKTileMapNode(tileSet: groundTileSet, columns: TileData.shared.maxCol, rows: TileData.shared.maxRow, tileSize: size)
        self.unitMap = SKTileMapNode(tileSet: objectTileSet, columns: TileData.shared.maxCol, rows: TileData.shared.maxRow, tileSize: size)
        self.viewWillAppear()
        addChild(self.tileMap)
        addChild(self.unitMap)
    }
    
    func viewWillAppear() {
        guard let groundTileSet = SKTileSet(named: "Ground Tiles") else {
            fatalError("groundTileSet not found")
        }
        
        let groundTileGroups = groundTileSet.tileGroups
        guard let grassTile = groundTileGroups.first(where: {$0.name == "Grass Tile"}) else {
            fatalError("Grass Tile definition found")
        }
        
        guard let waterTile = groundTileGroups.first(where: {$0.name == "Water Tile"}) else {
            fatalError("Water Tile definition found")
        }
        
        guard let objectTileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        let objectTileGroups = objectTileSet.tileGroups
        guard let duckTile = objectTileGroups.first(where: {$0.name == "Duck"}) else {
            fatalError("No Duck tile definition found")
        }
        
        for y in 0..<TileData.shared.tiles.count {
            let cols = TileData.shared.tiles[y]
            for x in 0..<cols.count {
                let value = cols[x]
                if value == 0 {
                    self.tileMap.setTileGroup(waterTile, forColumn: x, row: y)
                }
                else {
                    self.tileMap.setTileGroup(grassTile, forColumn: x, row: y)
                }
            }
        }
        
        if TileData.shared.startPoint.x != -1 {
            self.unitMap.setTileGroup(duckTile, forColumn: Int(TileData.shared.startPoint.x), row: Int(TileData.shared.startPoint.y))
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let col = self.tileMap.tileColumnIndex(fromPosition: pos)
        let row = self.tileMap.tileRowIndex(fromPosition: pos)
        if col < 0 || row < 0 {
            return
        }
        
        GameStatus.shared.touchUp(row: row, col: col, tileMap: self.tileMap, unitMap: self.unitMap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
