//
//  ScramblerViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 5/24/21.
//

import UIKit

class ScramblerViewController: UIViewController {

    var _cell: [UIImageView]!
    override func viewDidLoad() {
        super.viewDidLoad()

        _cell = []
        for tag in stride(from: 1, through: 9, by: 1) {
            let imageView = view.viewWithTag(tag) as! UIImageView
            _cell.append(imageView)
        }
        refresh()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = view.frame.width / 3
        for i in stride(from: 0, to: 3, by: 1) {
            for j in stride(from: 0, to: 3, by: 1) {
                let pos = CGPoint(x: size*CGFloat(i), y: size*CGFloat(j))
                _cell[i*3+j].frame = CGRect(x: pos.x, y: pos.y, width: size, height: size)
            }
        }
    }
    func refresh() {
        for i in stride(from: 0, to: 9, by: 1) {
            _cell[i].image = TileDash.getImage(value: TileDash._scrambler[i])
        }
    }
}
