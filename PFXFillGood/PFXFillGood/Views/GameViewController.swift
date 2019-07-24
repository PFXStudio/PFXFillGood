//
//  GameViewController.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 25..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GKScene?
    var gameScene: GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.gameScene == nil) {
            if let scene = GKScene(fileNamed: "GameScene") {
                self.scene = scene
                
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! GameScene? {
                    self.gameScene = sceneNode
                    
                    // Copy gameplay related content over to the scene
                    sceneNode.entities = scene.entities
                    sceneNode.graphs = scene.graphs
                    
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
                    
                    // Present the scene
                    if let view = self.view as! SKView? {
                        view.presentScene(sceneNode)
                        
                        view.ignoresSiblingOrder = true
                        
                        //                    view.showsFPS = true
                        //                    view.showsNodeCount = true
                    }
                }
            }
        }
        
        self.gameScene?.ready()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.gameScene == nil) {
            return
        }
        
        self.gameScene?.paused()
        if let view = self.view as! SKView? {
            self.gameScene?.removeFromParent()
            view.presentScene(nil)
            self.gameScene = nil
        }
    }
    
    func changedTileCount(row: Int, col: Int) {
        self.gameScene?.clearTile()
        TileData.shared.row = row
        TileData.shared.col = col
        TileData.shared.tiles = Array(repeating: Array(repeating: 1, count:col), count: row)
        
        self.gameScene?.ready()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
