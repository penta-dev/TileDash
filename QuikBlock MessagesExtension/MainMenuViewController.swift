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
                
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        layout.caption = "Let's play QuikBlock"
        message.layout = layout
        message.url = QuikBlock.getURLComponents().url

        MessagesViewController.messagesVC.activeConversation?.send(message, completionHandler: { error in
        })
        MessagesViewController.messagesVC.dismiss()
    }
}
