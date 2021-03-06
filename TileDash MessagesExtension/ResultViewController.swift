//
//  AdsViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 6/18/21.
//

import UIKit
import Messages
import GoogleMobileAds

class ResultViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var _lbTime: UILabel!
    @IBOutlet weak var _lbScore: UILabel!
    
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnRematch: UIButton!
    @IBOutlet weak var btnQuit: UIButton!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    private var interstitial: GADInterstitialAd?
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAD();
        
        lbDescription.text = ""
        btnRematch.isHidden = true
        btnQuit.isHidden = true
        
        constraintHeight.constant = constraintHeight.constant - 70
        
        // ad process
        if false == UserDefaults.standard.bool(forKey: StoreVC.remove_ads_key) {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { t in
                self.showAD()
                self.afterAD()
            }
        }else{// remove ads
            self.afterAD()
        }
        
        // show time and score
        _lbTime.text = TileDash.time_string()
        _lbScore.text = "\(TileDash._my_score!)"
        
        // check rematch signal
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if TileDash._my_score == 0 && TileDash._op_score == 0 {
                self.lbDescription.text = "Opponent wants to play again."
            }
        }
    }
    func showAD() {
        if Int.random(in: 0...100) < 70 && interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        }else{
        }
    }
    func afterAD() {
        btnRematch.isHidden = false
        btnQuit.isHidden = false
        constraintHeight.constant = constraintHeight.constant + 70
        self.view.layoutIfNeeded()
    }
    @IBAction func clickedRematch(_ sender: Any) {
        if TileDash._my_score == 0 && TileDash._op_score == 0 {// accept rematch
            self.dismiss(animated: true, completion: nil)
        }else{  // want rematch
            btnRematch.isHidden = true
            lbDescription.text = "Waiting for opponent's accepting..."
            TileDash.sendRematch()
        }
    }
    @IBAction func clickedQuit(_ sender: Any) {
        MessagesViewController.messagesVC.dismiss()
    }
    
    func loadAD() {
        // interstitial
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-8304133905640357/2441338341",
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                            }else{
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                            }
                          }
        )
    }
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    }

    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      loadAD()
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    }
}
