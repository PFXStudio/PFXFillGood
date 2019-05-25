//
//  TileCountViewController.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

class TileCountViewController: UIViewController {

    @IBOutlet weak var colSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rowSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        TileData.shared.col = self.colSegmentedControl.selectedSegmentIndex + 1
        TileData.shared.row = self.rowSegmentedControl.selectedSegmentIndex + 1

        TileData.shared.tiles = Array(repeating: Array(repeating: 0, count: TileData.shared.maxCol), count: TileData.shared.maxRow)
        for row in 0..<TileData.shared.maxRow {
            for col in 0..<TileData.shared.maxCol {
                if col >= TileData.shared.col || row >= TileData.shared.row {
                    TileData.shared.tiles[row][col] = 0
                    continue
                }
                
                TileData.shared.tiles[row][col] = 1
            }
        }
    }
}
