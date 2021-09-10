//
//  TutorialViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 6/24/21.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var hand: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let x:CGFloat = view.bounds.width * 0.45
        UIView.animate(withDuration: 1, delay: 0.5, options: [.repeat, .autoreverse], animations: {
                self.hand.center.x = x
        }, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
