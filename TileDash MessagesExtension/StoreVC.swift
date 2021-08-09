//
//  StoreViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 7/9/21.
//

import UIKit
import StoreKit

class StoreVC: UIViewController {
    static let remove_ads_key = "tiledash_remove_ads"
    static let dino_theme_key = "tiledash_theme_dino"
    static let space_theme_key = "tiledash_theme_space"
    static let theme_index_key = "tiledash_theme_index"
    static let theme_normal_id = 0
    static let theme_dino_id = 1
    static let theme_space_id = 2

    // dino theme
    @IBOutlet weak var imageDinoLock: UIImageView!
    @IBOutlet weak var lbDinoPrice: UILabel!
    
    // space theme
    @IBOutlet weak var imageSpaceLock: UIImageView!
    @IBOutlet weak var lbSpacePrice: UILabel!
    
    // Ads
    @IBOutlet weak var lbAds: UILabel!
    @IBOutlet weak var btnAds: UIButton!
    @IBOutlet weak var lbAdsPrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    @IBAction func onClickedHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func OnClickDino(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: StoreVC.dino_theme_key) { // purchased
            UserDefaults.standard.set(StoreVC.theme_dino_id, forKey: StoreVC.theme_index_key) // choose
            refresh()
        }else{
            IAP.purchaseProduct(StoreVC.dino_theme_key, handler: { (productIdentifier, error) in
                if productIdentifier != nil {
                    UserDefaults.standard.set(true, forKey: StoreVC.dino_theme_key)  // purchase
                    UserDefaults.standard.set(StoreVC.theme_dino_id, forKey: StoreVC.theme_index_key) // choose dino
                    self.refresh()
                } else if let error = error as NSError? {
                    if error.code == SKError.Code.paymentCancelled.rawValue {
                      // User cancelled
                    } else {
                      // Some error happened
                    }
                }
            })
        }
    }
    @IBAction func OnClickSpace(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: StoreVC.space_theme_key) { // purchased
            UserDefaults.standard.set(StoreVC.theme_space_id, forKey: StoreVC.theme_index_key)    // choose space
            self.refresh()
        }else{
            IAP.purchaseProduct(StoreVC.dino_theme_key, handler: { (productIdentifier, error) in
                if productIdentifier != nil {
                    UserDefaults.standard.set(true, forKey: StoreVC.space_theme_key)  // purchase
                    UserDefaults.standard.set(StoreVC.theme_space_id, forKey: StoreVC.theme_index_key)    // choose space
                    self.refresh()
                } else if let error = error as NSError? {
                    if error.code == SKError.Code.paymentCancelled.rawValue {
                      // User cancelled
                    } else {
                      // Some error happened
                    }
                }
            })
        }
    }
    @IBAction func OnClickNoAds(_ sender: Any) {
        IAP.purchaseProduct(StoreVC.remove_ads_key, handler: { (productIdentifier, error) in
            if productIdentifier != nil {
                UserDefaults.standard.set(true, forKey: StoreVC.remove_ads_key)  // purchase
                self.refresh()
            } else if let error = error as NSError? {
                if error.code == SKError.Code.paymentCancelled.rawValue {
                  // User cancelled
                } else {
                  // Some error happened
                }
            }
        })
    }
    func refresh()
    {
        // purchased remove-ads
        if UserDefaults.standard.bool(forKey: StoreVC.remove_ads_key) {
            lbAds.isHidden = true
            btnAds.isHidden = true
            lbAdsPrice.isHidden = true
        }
        
        let theme_id = UserDefaults.standard.integer(forKey: StoreVC.theme_index_key)   // current theme
        
        // purchased dino theme
        if UserDefaults.standard.bool(forKey: StoreVC.dino_theme_key) {
            imageDinoLock.isHidden = true
            if theme_id == StoreVC.theme_dino_id {
                lbDinoPrice.text = "Using"
            }else{
                lbDinoPrice.text = "Tap to use"
            }
        }
        
        // purchased space theme
        if UserDefaults.standard.bool(forKey: StoreVC.space_theme_key) {
            imageSpaceLock.isHidden = true
            if theme_id == StoreVC.theme_space_id {
                lbSpacePrice.text = "Using"
            }else{
                lbSpacePrice.text = "Tap to use"
            }
        }
    }
}
