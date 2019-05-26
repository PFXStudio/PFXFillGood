//
//  StartViewController.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GameStatus.shared = StartStatus()
        
        var log = ""
        for tiles in TileData.shared.tiles {
            for col in tiles {
                log = log + "\(col) "
            }
            
            log = log + "\n"
        }
        
        print(log)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func recursivePath(parentTiles: [[Int]], parentPaths: [CGPoint]) -> (Bool, [CGPoint]) {
        var tiles = parentTiles
        guard let start = parentPaths.last else {
            return (false, [])
        }
        
        var paths = parentPaths
        let startX = Int(start.x)
        let startY = Int(start.y)
        var value = tiles[startY][startX]
        if value == 0 {
            return (false, [])
        }
        
        tiles[startY][startX] = 0
        var x = startX - 1
        if x >= 0 {
            value = TileData.shared.tiles[startY][x]
            if value == 1 {
                paths.append(CGPoint(x: x, y: startY))
                let result = recursivePath(parentTiles: tiles, parentPaths: paths)
                if result.0 == false {
                    paths.removeLast()
                }
                else {
                    return result
                }
            }
        }
        
        x = startX + 1
        if x < TileData.shared.col {
            value = TileData.shared.tiles[startY][x]
            if value == 1 {
                paths.append(CGPoint(x: x, y: startY))
                let result = recursivePath(parentTiles: tiles, parentPaths: paths)
                if result.0 == false {
                    paths.removeLast()
                }
                else {
                    return result
                }
            }
        }
        
        var y = startY - 1
        if y >= 0 {
            value = TileData.shared.tiles[y][startX]
            if value == 1 {
                paths.append(CGPoint(x: startX, y: y))
                let result = recursivePath(parentTiles: tiles, parentPaths: paths)
                if result.0 == false {
                    paths.removeLast()
                }
                else {
                    return result
                }
            }
        }
        
        y = startY + 1
        if y < TileData.shared.row {
            value = TileData.shared.tiles[y][startX]
            if value == 1 {
                paths.append(CGPoint(x: startX, y: y))
                let result = recursivePath(parentTiles: tiles, parentPaths: paths)
                if result.0 == false {
                    paths.removeLast()
                }
                else {
                    return result
                }
            }
        }
        
        for row in 0..<TileData.shared.row {
            for col in 0..<TileData.shared.col {
                let value = tiles[row][col]
                if value == 1 {
                    return (false, [])
                }
            }
        }
        
        print("find \(parentPaths)")
        return (true, parentPaths)
    }
    
    @IBAction func touchedStartButton(_ sender: Any) {
        if TileData.shared.startPoint.x == -1 {
            return
        }
        
        let tiles = TileData.shared.tiles
        var paths = [CGPoint]()
        paths.append(TileData.shared.startPoint)
        DispatchQueue.global().async {
            let result = self.recursivePath(parentTiles: tiles, parentPaths: paths)
            if result.0 == true {
                TileData.shared.paths = result.1
            }
        }
    }

    /*
    @IBAction func touchedStartButton(_ sender: Any) {
        if TileData.shared.startPoint.x == -1 {
            return
        }
        
        let graph = Graph(TileData.shared.row * TileData.shared.col)
        for row in 0..<TileData.shared.row {
            for col in 0..<TileData.shared.col {
                var value = TileData.shared.tiles[row][col]
                if value == 0 {
                    continue
                }
                
                let index = (row * TileData.shared.row) + col
                var x = col - 1
                if x >= 0 {
                    value = TileData.shared.tiles[row][x]
                    if value == 1 {
                        let left = (row * TileData.shared.row) + x
                        graph.addEdge(left: index, right: left)
                    }
                }
                
                x = col + 1
                if x < TileData.shared.col {
                    value = TileData.shared.tiles[row][x]
                    if value == 1 {
                        let right = (row * TileData.shared.row) + x
                        graph.addEdge(left: index, right: right)
                    }
                }
                
                var y = row - 1
                if y >= 0 {
                    value = TileData.shared.tiles[y][col]
                    if value == 1 {
                        let down = (y * TileData.shared.row) + col
                        graph.addEdge(left: index, right: down)
                    }
                }

                y = row + 1
                if y < TileData.shared.row {
                    value = TileData.shared.tiles[y][col]
                    if value == 1 {
                        let up = (y * TileData.shared.row) + col
                        graph.addEdge(left: index, right: up)
                    }
                }
            }
        }
        
        let visits = graph.visitDfs(0)
        for val in visits {
            let y = val / TileData.shared.row
            let x = val % TileData.shared.row
            print("x : \(x) y : \(y)")
        }
    }
 
 */
}
