//
//  WinnerViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 6/2/21.
//

import UIKit

class WinnerViewController: ResultViewController {

    @IBOutlet weak var _lbTime: UILabel!
    @IBOutlet weak var _lbScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _lbTime.text = TileDash.time_string()
        _lbScore.text = "\(TileDash._my_score!)"
    }    
}
