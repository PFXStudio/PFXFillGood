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
    var arrowMap:SKTileMapNode!

    override func sceneDidLoad() {

        print("\(#function), \(#line)")
        self.lastUpdateTime = 0
        self.backgroundColor = UIColor.white
    }
    
//    override func didMove(to view: SKView) {
//        print("\(#function), \(#line)")
//        self.ready()
//    }
    
    func ready() {
        print("\(#function), \(#line)")
        let size = CGSize(width: 50, height: 50)
        guard let groundTileSet = SKTileSet(named: "Ground Tiles") else {
            fatalError("groundTileSet not found")
        }
        
        guard let objectTileSet = SKTileSet(named: "Object Tiles") else {
            fatalError("Object Tiles Tile Set not found")
        }
        
        guard let arrowTileSet = SKTileSet(named: "Arrow Tiles") else {
            fatalError("arrowTileSet Tiles Tile Set not found")
        }
        
        let groundTileGroups = groundTileSet.tileGroups
        guard let grassTile = groundTileGroups.first(where: {$0.name == "Grass Tile"}) else {
            fatalError("Grass Tile definition found")
        }
        
        guard let waterTile = groundTileGroups.first(where: {$0.name == "Water Tile"}) else {
            fatalError("Water Tile definition found")
        }
        
        if self.tileMap != nil {
            self.tileMap.removeFromParent()
        }
        
        if self.unitMap != nil {
            self.unitMap.removeFromParent()
        }
        
        if self.arrowMap != nil {
            self.arrowMap.removeFromParent()
        }
        
        self.removeAllChildren()
        
        self.tileMap = SKTileMapNode(tileSet: groundTileSet, columns: TileData.shared.col, rows: TileData.shared.row, tileSize: size)
        self.unitMap = SKTileMapNode(tileSet: objectTileSet, columns: TileData.shared.col, rows: TileData.shared.row, tileSize: size)
        self.arrowMap = SKTileMapNode(tileSet: arrowTileSet, columns: TileData.shared.col, rows: TileData.shared.row, tileSize: size)
        addChild(self.tileMap)
        addChild(self.unitMap)
        addChild(self.arrowMap)

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
        
        self.isPaused = false
        if TileData.shared.paths.count <= 0 {
            return
        }

        if GameStatus.shared.isKind(of: CompleteStatus.self) == false {
            print(">>>completeStatus \(#function), \(#line)")
            GameStatus.shared = CompleteStatus()
        }
    }
    
    func clearUnit() {
        for row in 0..<TileData.shared.row {
            for col in 0..<TileData.shared.col {
                self.unitMap.setTileGroup(nil, forColumn: col, row: row)
                self.arrowMap.setTileGroup(nil, forColumn: col, row: row)
            }
        }
        
        TileData.shared.paths.removeAll()
    }
    
    func clearTile() {
        if (self.tileMap == nil) {
            return
        }
        
        for row in 0..<TileData.shared.row {
            for col in 0..<TileData.shared.col {
                self.tileMap.setTileGroup(nil, forColumn: col, row: row)
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        // Update entities
        // Calculate time since last update
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }

        let dt = currentTime - self.lastUpdateTime
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        if TileData.shared.paths.count <= 0 {
            return
        }
        
        if GameStatus.shared.isKind(of: CompleteStatus.self) == true {
            GameStatus.shared.showCompleted(currentTime, scene: self, unitMap: self.unitMap, arrowMap: self.arrowMap)
        }
    }
    
    func paused() {
        self.clearUnit()
        self.isPaused = true
        
        TileData.shared.initializeStartPoint()
    }

    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let col = self.tileMap.tileColumnIndex(fromPosition: pos)
        let row = self.tileMap.tileRowIndex(fromPosition: pos)
        if col < 0 || row < 0 {
            return
        }
        
        GameStatus.shared.touchUp(row: row, col: col, tileMap: self.tileMap, unitMap: self.unitMap, arrowMap: self.arrowMap)
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
    
}
