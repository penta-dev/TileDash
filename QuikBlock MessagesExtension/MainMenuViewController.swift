//
//  MainMenuViewController.swift
//  QuikBlock MessagesExtension
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
        QuikBlock.start()
        
        let session = MSSession()
        let message = MSMessage(session: session)
        let layout = MSMessageTemplateLayout()
        layout.caption = "Let's play Quik Block"
        message.layout = layout
        message.url = QuikBlock.getURLComponents().url

        MessagesViewController.messagesVC.activeConversation?.send(message, completionHandler: { error in
        })
        MessagesViewController.messagesVC.dismiss()
    }
    
    @IBAction func onClickedPurchase(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(identifier: "StoreViewController") as! StoreViewController
        present(controller, animated: true, completion: nil)
        MessagesViewController.messagesVC.requestPresentationStyle(.expanded)
    }
}
