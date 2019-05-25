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
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

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
                        print("index \(left) x : \(x) y : \(row)")
                    }
                }
                
                x = col + 1
                if x < TileData.shared.col {
                    value = TileData.shared.tiles[row][x]
                    if value == 1 {
                        let right = (row * TileData.shared.row) + x
                        graph.addEdge(left: index, right: right)
                        print("index \(right) x : \(x) y : \(row)")
                    }
                }
                
                var y = row - 1
                if y >= 0 {
                    value = TileData.shared.tiles[y][col]
                    if value == 1 {
                        let down = (y * TileData.shared.row) + x
                        graph.addEdge(left: index, right: down)
                        print("index \(down) x : \(x) y : \(row)")
                    }
                }

                y = row + 1
                if y >= TileData.shared.row {
                    value = TileData.shared.tiles[y][col]
                    if value == 1 {
                        let up = (y * TileData.shared.row) + x
                        graph.addEdge(left: index, right: up)
                        print("index \(up) x : \(x) y : \(row)")
                    }
                }
            }
        }
        
        let visits = graph.visitDfs(0)
        print(visits)
    }
}
