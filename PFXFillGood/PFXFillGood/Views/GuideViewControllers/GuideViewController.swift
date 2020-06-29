//
//  GuideViewController.swift
//  BitMoon
//
//  Created by succorer on 2018. 10. 23..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import StoreKit
import paper_onboarding
import ProgressHUD
import ConcentricOnboarding

class GuideViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var paperView: PaperOnboarding!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.paperView.delegate = self
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if (index < 3) {
            return
        }
        
        let alertController = UIAlertController(title: NSLocalizedString("alertTitle", comment: ""), message: NSLocalizedString("playFill", comment: ""), preferredStyle: .alert)
        
        let installAction = UIAlertAction(title: NSLocalizedString("buttonStore", comment: ""), style: .default) { (action) in
            self.openStoreProductWithiTunesItemIdentifier(identifier: "1091456207")
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("buttonDid", comment: ""), style: .cancel) { (action) in
            self.dismiss(animated: false, completion: nil)
        }
        
        alertController.addAction(installAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        ProgressHUD.show(NSLocalizedString("loading", comment: ""))
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            ProgressHUD.dismiss()
            if loaded {
                // Parent class of self is UIViewContorller
                self?.present(storeViewController, animated: true, completion: nil)
                return
            }
            
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func onboardingItemsCount() -> Int {
        return 4;
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bottomImage: UIImage = UIImage(named: "iconPivot")!
        let guide1Image: UIImage = UIImage(named: "guide01")!
        let guide2Image: UIImage = UIImage(named: "guide02")!
        let guide3Image: UIImage = UIImage(named: "guide03")!

        return [
            OnboardingItemInfo(informationImage: guide1Image,
                               title: "",
                               description: NSLocalizedString("guideContents1", comment: ""),
                               pageIcon: bottomImage,
                               color: DefineColors.kMainTintColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 18),
                               descriptionFont: UIFont.systemFont(ofSize: 14)),
            
            OnboardingItemInfo(informationImage: guide2Image,
                               title: "",
                               description: NSLocalizedString("guideContents2", comment: ""),
                               pageIcon: bottomImage,
                               color: DefineColors.kUpPercentageColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 18),
                            descriptionFont: UIFont.systemFont(ofSize: 14)),

            OnboardingItemInfo(informationImage: guide3Image,
                               title: "",
                               description: NSLocalizedString("guideContents3", comment: ""),
                               pageIcon: bottomImage,
                               color: DefineColors.kUpPercentageColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 18),
                               descriptionFont: UIFont.systemFont(ofSize: 14)),

            OnboardingItemInfo(informationImage: guide3Image,
                               title: "",
                               description: NSLocalizedString("guideContents3", comment: ""),
                               pageIcon: bottomImage,
                               color: DefineColors.kUpPercentageColor,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.boldSystemFont(ofSize: 18),
                               descriptionFont: UIFont.systemFont(ofSize: 14)),
            ][index]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
