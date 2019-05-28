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

class GuideViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var paperView: PaperOnboarding!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.paperView.delegate = self
        
        if UserDefaults.standard.bool(forKey: DefineStrings.kCompletedGuide) == true {
            self.showMain()
            return
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if (index < 3) {
            return
        }
        
        self.checkInstalled()
    }
    
    func checkInstalled() {
        let app = UIApplication.shared
        let url = URL(string: "fill://")!
        if app.canOpenURL(url) {
            self.showMain()
            return
        }

        print("App in not installed. Go to AppStore")
        // Not installed Alert -> go to appstore
        let alertController = UIAlertController(title: NSLocalizedString("alertTitle", comment: ""), message: NSLocalizedString("needFillInstall", comment: ""), preferredStyle: .alert)
        
        let installAction = UIAlertAction(title: NSLocalizedString("buttonInstall", comment: ""), style: .default) { (action) in
            self.openStoreProductWithiTunesItemIdentifier(identifier: "1091456207")
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("buttonCancel", comment: ""), style: .cancel) { (action) in
            self.showMain()
        }
        
        alertController.addAction(installAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                self?.present(storeViewController, animated: true, completion: nil)
                return
            }
            
            self?.showMain()
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
        self.showMain()
    }
    
    func showMain() {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "MainNavigationController")
        self .present(viewController, animated: false, completion: nil)

        UserDefaults.standard.set(true, forKey: DefineStrings.kCompletedGuide)
    }
    
    func onboardingItemsCount() -> Int {
        return 4;
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bottomImage: UIImage = UIImage(named: "iconMore")!
        let guide1Image: UIImage = UIImage(named: "guide-1")!
        let guide2Image: UIImage = UIImage(named: "guide-2")!
        let guide3Image: UIImage = UIImage(named: "guide-3")!

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
