//
//  MainMenuViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 5/24/21.
//

import UIKit
import Messages

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onClickedStart(_ sender: Any) {
        TileDash.start()
        
        let session = MSSession()
        let message = MSMessage(session: session)
        let layout = MSMessageTemplateLayout()
        layout.caption = "Let's play Tile Dash"
        message.layout = layout
        message.url = TileDash.getURLComponents().url

        MessagesViewController.messagesVC.activeConversation?.send(message, completionHandler: { error in
        })
        MessagesViewController.messagesVC.dismiss()
    }
    
    @IBAction func onClickedPurchase(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(identifier: "StoreViewController") as! StoreVC
        present(controller, animated: true, completion: nil)
        MessagesViewController.messagesVC.requestPresentationStyle(.expanded)
    }
}
