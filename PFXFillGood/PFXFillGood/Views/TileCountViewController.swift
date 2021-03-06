//
//  TileCountViewController.swift
//  PFXFillGood
//
//  Created by PFXStudio on 2019. 5. 26..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import SwiftUI

class TileCountViewController: UIViewController {

    @IBOutlet weak var infoBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var colSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rowSegmentedControl: UISegmentedControl!
    var gameViewController: GameViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("tileCountTitle", comment: "")
        self.nextButton.roundLayer()
        
        if UserDefaults.standard.bool(forKey: DefineStrings.kCompletedGuide) == false {
            self.showGuide()
            return
        }
    }
    
    @IBAction func touchedInfoBarButtonItem(_ sender: UIBarButtonItem) {
        self.showGuide()
    }
    
    func showGuide() {
        let viewController = UIStoryboard.init(name: "Guide", bundle: nil) .instantiateViewController(withIdentifier: "GuideViewController")
        viewController.modalPresentationStyle = .fullScreen
        self .present(viewController, animated: false, completion: nil)
        
        UserDefaults.standard.set(true, forKey: DefineStrings.kCompletedGuide)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GameStatus.shared = TileCountStatus()
        self.gameViewController?.changedTileCount(row: self.rowSegmentedControl.selectedSegmentIndex + 1, col: self.colSegmentedControl.selectedSegmentIndex + 1)
    }
    
    @IBAction func changedColSegment(_ sender: Any) {
        self.gameViewController?.changedTileCount(row: self.rowSegmentedControl.selectedSegmentIndex + 1, col: self.colSegmentedControl.selectedSegmentIndex + 1)
    }
    
    @IBAction func changedRowSegment(_ sender: Any) {
        self.gameViewController?.changedTileCount(row: self.rowSegmentedControl.selectedSegmentIndex + 1, col: self.colSegmentedControl.selectedSegmentIndex + 1)
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
}
