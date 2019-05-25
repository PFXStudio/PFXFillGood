//
//  TileData.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 25..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

struct TileData {
    static var shared = TileData()

    let maxRow = 7
    let maxCol = 7
    var row = 1
    var col = 1
    var tiles = [[Int]]()
    
    var startPoint = CGPoint(x: -1, y: -1)
}
