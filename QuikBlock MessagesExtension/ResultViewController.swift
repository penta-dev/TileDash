//
//  AdsViewController.swift
//  QuikBlock MessagesExtension
//
//  Created by dev on 6/18/21.
//

import UIKit
import GoogleMobileAds

class ResultViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnRematch: UIButton!
    @IBOutlet weak var btnQuit: UIButton!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    private var interstitial: GADInterstitialAd?
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAD();
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { t in
            self.showAD();
        }
        
        lbDescription.text = ""
        btnRematch.isHidden = true
        btnQuit.isHidden = true
        
        constraintHeight.constant = constraintHeight.constant - 70
    }
    func showAD() {
        if Int.random(in: 0...100) < 70 && interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        }else{
        }
        btnRematch.isHidden = false
        btnQuit.isHidden = false
        constraintHeight.constant = constraintHeight.constant + 70
        self.view.layoutIfNeeded()
    }
    @IBAction func clickedRematch(_ sender: Any) {
        btnRematch.isHidden = true
        lbDescription.text = "Waiting for opponent's accepting..."
    }
    @IBAction func clickedQuit(_ sender: Any) {
        MessagesViewController.messagesVC.dismiss()
    }
    
    func loadAD() {
        // interstitial
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
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
