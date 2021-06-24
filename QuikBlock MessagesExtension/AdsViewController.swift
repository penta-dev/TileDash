//
//  AdsViewController.swift
//  QuikBlock MessagesExtension
//
//  Created by dev on 6/18/21.
//

import UIKit
import GoogleMobileAds

class AdsViewController: UIViewController, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAD();
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { t in
            self.showAD();
        }
    }
    func showAD() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }
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
