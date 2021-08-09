//
//  GameViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 5/22/21.
//

import UIKit
import GoogleMobileAds

class GameViewController: UIViewController {

    @IBOutlet weak var _bannerView: GADBannerView!
    
    @IBOutlet weak var _lbScore: UILabel!
    @IBOutlet weak var _lbTime: UILabel!
    
    @IBOutlet weak var _containerScrambler: UIView!
    @IBOutlet weak var _containerOpponent: UIView!
    @IBOutlet weak var _containerBoard: UIView!
        
    var _scramblerVC: ScramblerViewController!
    var _boardVC: BoardViewController!
    var _opponentVC: BoardViewController!
    var _waitingAC: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentScrambler()
        presentOpponent()
        presentBoard()
        
        updateScore()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            TileDash._time += 1
            self._lbTime.text = TileDash.time_string()
        }
        
        // Tutorial
        presentTutorial()
        
        // Admob Banner
        if false == UserDefaults.standard.bool(forKey: StoreVC.remove_ads_key) {            
            _bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            _bannerView.rootViewController = self
            _bannerView.load(GADRequest())
        }
    }
    public func presentWaiting() {
        _waitingAC = UIAlertController(title: nil, message: "Please wait for opponent...", preferredStyle: .alert)
        present(_waitingAC!, animated: true, completion: nil)
    }
    func updateOpponent() {
        _opponentVC.setBoard(TileDash._opponent)
        if let ac = _waitingAC {    // remove waiting... alert
            ac.dismiss(animated: true, completion: nil)
            _waitingAC = nil
        }
    }
    func updateScore() {
        _lbScore.text = String(TileDash._my_score)
    }
    private func presentScrambler() {
        let controller = storyboard!.instantiateViewController(identifier: "ScramblerViewController") as ScramblerViewController
        
        controller._theme = TileDash._my_theme
        
        controller.willMove(toParent: self)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.leftAnchor.constraint(equalTo: _containerScrambler.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: _containerScrambler.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: _containerScrambler.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: _containerScrambler.bottomAnchor).isActive = true
        controller.didMove(toParent: self)
        
        _scramblerVC = controller
    }
    private func presentOpponent() {
        let controller = storyboard!.instantiateViewController(identifier: "BoardViewController") as BoardViewController
        
        controller._touchEnable = false
        controller.initCellViews()
        controller._theme = TileDash._op_theme
        controller.setBoard(TileDash._opponent)
        
        controller.willMove(toParent: self)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.leftAnchor.constraint(equalTo: _containerOpponent.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: _containerOpponent.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: _containerOpponent.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: _containerOpponent.bottomAnchor).isActive = true
        controller.didMove(toParent: self)
        
        _opponentVC = controller
    }
    private func presentBoard() {
        let controller = storyboard!.instantiateViewController(identifier: "BoardViewController") as BoardViewController
        
        controller._touchEnable = true
        controller.initCellViews()
        controller._theme = TileDash._my_theme
        controller.setBoard(TileDash._me)
        controller._gameVC = self
        
        controller.willMove(toParent: self)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.leftAnchor.constraint(equalTo: _containerBoard.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: _containerBoard.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: _containerBoard.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: _containerBoard.bottomAnchor).isActive = true
        controller.didMove(toParent: self)
        
        _boardVC = controller
    }
    private func presentTutorial() {
        let controller = storyboard!.instantiateViewController(identifier: "TutorialViewController") as TutorialViewController
                
        controller.willMove(toParent: self)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        controller.didMove(toParent: self)
    }
}
