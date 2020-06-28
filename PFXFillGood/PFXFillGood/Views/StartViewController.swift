//
//  StartViewController.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import AudioToolbox
import GoogleMobileAds
import ProgressHUD

class StartViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var searchButton: UIButton!
    var interstitial: GADInterstitial!
    var gameViewController: GameViewController?
    var results: [CGPoint]?
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("startTitle", comment: "")
        interstitial = createAndLoadInterstitial()
        self.searchButton.roundLayer()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-6807878951364224/7374673629")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        TileData.shared.paths = self.results!
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
    
    func recursivePath(parentTiles: [[Int]], direction: (Int), parentPaths: [CGPoint]) -> (Bool, [CGPoint]) {
        if self.results != nil {
            return (false, [])
        }

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
        
        var x = startX + (-1 * direction)
        if 0 <= x && x < TileData.shared.col {
            value = TileData.shared.tiles[startY][x]
            if value == 1 {
                paths.append(CGPoint(x: x, y: startY))
                let result = recursivePath(parentTiles: tiles, direction: direction, parentPaths: paths)
                if result.0 == false {
                    paths.removeLast()
                }
                else {
                    return result
                }
            }
        }
        
        var y = startY + (-1 * direction)
        if 0 <= y && y < TileData.shared.row {
            value = TileData.shared.tiles[y][startX]
            if value == 1 {
                paths.append(CGPoint(x: startX, y: y))
                let result = recursivePath(parentTiles: tiles, direction: direction, parentPaths: paths)
                if result.0 == false {
                    paths.removeLast()
                }
                else {
                    return result
                }
            }
        }
        
        x = startX + (1 * direction)
        if 0 <= x && x < TileData.shared.col {
            value = TileData.shared.tiles[startY][x]
            if value == 1 {
                paths.append(CGPoint(x: x, y: startY))
                let result = recursivePath(parentTiles: tiles, direction: direction, parentPaths: paths)
                if result.0 == false {
                    paths.removeLast()
                }
                else {
                    return result
                }
            }
        }
        
        y = startY + (1 * direction)
        if 0 <= y && y < TileData.shared.row {
            value = TileData.shared.tiles[y][startX]
            if value == 1 {
                paths.append(CGPoint(x: startX, y: y))
                let result = recursivePath(parentTiles: tiles, direction: direction, parentPaths: paths)
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
        
        if TileData.shared.row * TileData.shared.col > 40 {
            let alertController = UIAlertController(title: NSLocalizedString("alertTitle", comment: ""), message: NSLocalizedString("longTimeSearch", comment: ""), preferredStyle: .alert)
            
            let startAction = UIAlertAction(title: NSLocalizedString("buttonSearch", comment: ""), style: .default) { (action) in
                self.executeSearch()
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("buttonCancel", comment: ""), style: .cancel) { (action) in
            }
            
            alertController.addAction(startAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
            return
        }

        self.executeSearch()
    }
    
    func executeSearch() {
        self.gameViewController?.gameScene?.clearUnit()
        self.results = nil
        let tiles = TileData.shared.tiles
        var paths = [CGPoint]()
        paths.append(TileData.shared.startPoint)
        
        ProgressHUD.show(String(format: NSLocalizedString("searchingPaths", comment: ""), 0), interaction: false)
        /*
         DispatchQueue.global().async {
         let result = self.recursivePath(parentTiles: tiles, direction: -1, parentPaths: paths)
         let endDate = Date()
         let interval = endDate.timeIntervalSince(startDate)
         print("work time : \(interval)")
         
         self.completed(result: result.0, pointPaths: result.1)
         }
         */
        var second = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            second = second + 1
            ProgressHUD.show(String(format: NSLocalizedString("searchingPaths", comment: ""), second), interaction: false)
        }
        
        DispatchQueue.global().async {
            let result = self.recursivePath(parentTiles: tiles, direction: 1, parentPaths: paths)
            self.completed(result: result.0, pointPaths: result.1)
        }
    }
    
    func completed(result:(Bool), pointPaths:([CGPoint])) {
        self.timer?.invalidate()
        self.timer = nil
        if result == true {
            ProgressHUD.showSuccess(NSLocalizedString("successPaths", comment: ""))
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.searchButton.isEnabled = false
                self.searchButton.alpha = 0.5
                if self.interstitial.isReady == true {
                    self.interstitial.present(fromRootViewController: self)
                    self.results = pointPaths
                }
                else {
                    // 광고 로딩 실패!
                    self.results = pointPaths
                    TileData.shared.paths = pointPaths
                    self.gameViewController?.viewWillAppear(false)
                }
            })
        }
        else {
            if self.results != nil {
                return
            }
            // no paths
            DispatchQueue.main.async {
                ProgressHUD.showError(NSLocalizedString("failPaths", comment: ""))
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
}
