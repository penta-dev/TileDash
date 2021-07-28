//
//  MessagesViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 5/6/21.
//

import UIKit
import Messages
import GoogleMobileAds
import os.log

class MessagesViewController: MSMessagesAppViewController {
    static var messagesVC: MessagesViewController!
    var gameVC: GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessagesViewController.messagesVC = self
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    }
    // MARK: - Conversation Handling
    override func willBecomeActive(with conversation: MSConversation) {
        if let messageURL = conversation.selectedMessage?.url {
            let components = URLComponents(url: messageURL, resolvingAgainstBaseURL: false)
            TileDash.setData(conversation:conversation, components: components!)
            presentGameViewController()
            checkWinner()
        } else {
            presentMainMenuViewController()
        }
    }
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        if TileDash.isMyMessage(conversation) {
            return
        }
        if let incomingSession = message.session {
            if incomingSession == conversation.selectedMessage?.session {
                if let messageURL = conversation.selectedMessage?.url {                    
                    let components = URLComponents(url: messageURL, resolvingAgainstBaseURL: false)
                    TileDash.setReady(conversation: conversation, components: components!)
                    TileDash.setOpponent(conversation: conversation, components: components!)
                    gameVC!.updateOpponent()
                    checkWinner()
                }
            }
        }
    }
    private func presentMainMenuViewController() {
        let controller = storyboard!.instantiateViewController(identifier: "MainMenuViewController") as! MainMenuViewController
        
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
    private func presentGameViewController() {
        let controller = storyboard!.instantiateViewController(identifier: "GameViewController") as! GameViewController
        controller.willMove(toParent: self)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        controller.didMove(toParent: self)
        
        gameVC = controller
    }
    func presentWinnerVC() {
        let controller = storyboard!.instantiateViewController(identifier: "WinnerViewController") as! WinnerViewController
        
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
    func presentLoserVC() {
        let controller = storyboard!.instantiateViewController(identifier: "LoserViewController") as! LoserViewController
        
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
    func checkWinner() {
        let result = TileDash.checkWinner()
        if result == 1 {
            presentWinnerVC()
        }
        if result == -1 {
            presentLoserVC()
        }
    }
}
