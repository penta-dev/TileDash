//
//  TipVC.swift
//  TileDash MessagesExtension
//
//  Created by dev on 9/9/21.
//

import UIKit

class TipVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // show gif image
        let gif = UIImage.gifImageWithName("TipMessage")
        imageView.image = gif
    }

    @IBAction func onClickedHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
