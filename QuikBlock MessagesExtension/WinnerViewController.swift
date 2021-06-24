//
//  WinnerViewController.swift
//  QuikBlock MessagesExtension
//
//  Created by dev on 6/2/21.
//

import UIKit

class WinnerViewController: AdsViewController {

    @IBOutlet weak var _lbTime: UILabel!
    @IBOutlet weak var _lbScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _lbTime.text = QuikBlock.time_string()
        _lbScore.text = "\(QuikBlock._my_score!)"
    }    
}
