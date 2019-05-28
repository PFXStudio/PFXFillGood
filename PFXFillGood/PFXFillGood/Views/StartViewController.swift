//
//  StartViewController.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import GoogleMobileAds
import ProgressHUD

class StartViewController: UIViewController, GADInterstitialDelegate {

    var interstitial: GADInterstitial!
    var gameViewController: GameViewController?
    var results = [CGPoint]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interstitial = createAndLoadInterstitial()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-6807878951364224/2401371946")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        TileData.shared.paths = self.results
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
        guard let gameViewController = segue.destination as? GameViewController else {
            return
        }

        self.gameViewController = gameViewController
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
            ProgressHUD.showError(NSLocalizedString("setStartPoint", comment: ""))
            return
        }
        
        self.gameViewController?.gameScene?.clearUnit()
        let tiles = TileData.shared.tiles
        var paths = [CGPoint]()
        paths.append(TileData.shared.startPoint)
        ProgressHUD.show(NSLocalizedString("searchingPaths", comment: ""), interaction: false)
        DispatchQueue.global().async {
            let result = self.recursivePath(parentTiles: tiles, parentPaths: paths)
            if result.0 == true {
                ProgressHUD.showSuccess(NSLocalizedString("successPaths", comment: ""))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    if self.interstitial.isReady == true {
                        self.interstitial.present(fromRootViewController: self)
                        self.results = result.1
                    }
                    else {
                        // 광고 로딩 실패!
                        TileData.shared.paths = result.1
                    }
                })
            }
            else {
                // no paths
                DispatchQueue.main.async {
                    ProgressHUD.showError(NSLocalizedString("failPaths", comment: ""))
                }
            }
        }
        
        /*
        // check tile
        var blockTileCount = 0
        for row in 0..<TileData.shared.row {
            for col in 0..<TileData.shared.col {
                var left = 0
                var right = 0
                var top = 0
                var bottom = 0
                let val = TileData.shared.tiles[row][col]
                if val == 0 {
                    continue
                }
                
                var x = col - 1
                if x >= 0 {
                    left = TileData.shared.tiles[row][x]
                }
                
                x = col + 1
                if x < TileData.shared.col {
                    right = TileData.shared.tiles[row][x]
                }
                
                var y = row - 1
                if y >= 0 {
                    bottom = TileData.shared.tiles[y][col]
                }
                
                y = row + 1
                if y < TileData.shared.row {
                    top = TileData.shared.tiles[y][col]
                }

                if left + right + bottom + top == 1 {
                    blockTileCount = blockTileCount + 1
                    if blockTileCount > 2 {
                        ProgressHUD.showError(NSLocalizedString("failPaths", comment: ""))
                        return
                    }
                }
            }
        }
        */
    }
}
