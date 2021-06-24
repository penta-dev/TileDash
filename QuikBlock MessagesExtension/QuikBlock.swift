//
//  QuikBlock.swift
//  QuikBlock MessagesExtension
//
//  Created by dev on 5/24/21.
//

import Foundation
import UIKit
import Messages

class QuikBlock {
    static var _time: Int = 0
    static var _ready: Bool!
    
    static var _my_score: Int!
    static var _op_score: Int!
    
    static var _scrambler: [Int]!
    static var _opponent: [[Int]]!
    static var _me: [[Int]]!
    
    static func time_string() -> String {
        let h = String(format: "%02d", _time/3600)
        let m = String(format: "%02d", (_time%3600)/60)
        let s = String(format: "%02d", _time%60)
        return "\(h):\(m):\(s)"
    }
    static func start() {
        _ready = false
        _my_score = 0
        _op_score = 0
        scramble()
        shuffleBoard()
    }
    private static func scramble() {
        repeat {
            _scrambler = []
            for _ in stride(from: 0, to: 9, by: 1) {
                let v = Int.random(in: 0..<6)
                _scrambler.append(v)
            }
        } while (checkScrambler() == false)
    }
    private static func checkScrambler() -> Bool {
        var count = [0,0,0,0,0,0]
        for v in _scrambler {
            count[v] += 1
        }
        for c in count {
            if c >= 4 {
                return false
            }
        }
        return true
    }
    private static func shuffleBoard() {
        _opponent = []
        _me = []
        var count: [Int] = [0,0,0,0,0,0]    // number of values
        for i in stride(from: 0, to: 5, by: 1) {
            var row: [Int] = []
            for j in stride(from: 0, to: 5, by: 1) {
                if i==4 && j == 4 {
                    row.append(-1)        // black
                }else{
                    // get possible values
                    var pv: [Int] = []
                    for k in stride(from: 0, to: 6, by: 1) {
                        if count[k] < 4 {
                            pv.append(k)
                        }
                    }
                    let index = Int.random(in: 0..<pv.count)
                    let value = pv[index]
                    row.append(value)
                    count[value] += 1
                }
            }
            _opponent.append(row)
            _me.append(row)
        }
    }
    static func getImage(value: Int) -> UIImage? {
        var str: String!
        switch value {
        case 0:
            str = "block_b.png"
            break
        case 1:
            str = "block_g.png"
            break
        case 2:
            str = "block_o.png"
            break
        case 3:
            str = "block_r.png"
            break
        case 4:
            str = "block_w.png"
            break
        case 5:
            str = "block_y.png"
            break
        default:
            str = ""
            break
        }
        return UIImage(named: str)
    }
    static func getURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.queryItems = []
        
        /*// sender uuid
        let senderQuery = URLQueryItem(name: "sender", value: UIDevice.current.identifierForVendor?.uuidString)
        urlComponents.queryItems?.append(senderQuery)*/
        
        // ready
        let readyQuery = URLQueryItem(name: "ready", value: "\(_ready!)")
        urlComponents.queryItems?.append(readyQuery)
        
        // score
        urlComponents.queryItems?.append(URLQueryItem(name: "my_score", value: "\(_my_score!)"))
        urlComponents.queryItems?.append(URLQueryItem(name: "op_score", value: "\(_op_score!)"))
        
        // scrambler
        for i in stride(from: 0, to: 9, by: 1) {
            let query = URLQueryItem(name: "scb\(i)", value: "\(_scrambler[i])")
            urlComponents.queryItems?.append(query)
        }
        
        // opponent
        for i in stride(from: 0, to: 5, by: 1) {
            for j in stride(from: 0, to: 5, by: 1) {
                let query = URLQueryItem(name: "opb\(i)\(j)", value: "\(_opponent[i][j])")
                urlComponents.queryItems?.append(query)
            }
        }
        
        // me
        for i in stride(from: 0, to: 5, by: 1) {
            for j in stride(from: 0, to: 5, by: 1) {
                let query = URLQueryItem(name: "meb\(i)\(j)", value: "\(_me[i][j])")
                urlComponents.queryItems?.append(query)
            }
        }
        
        return urlComponents
    }
    static func isMyMessage(_ conversation: MSConversation) -> Bool {
        //return true //test
        if let msg = conversation.selectedMessage {
            if msg.senderParticipantIdentifier.uuidString == conversation.localParticipantIdentifier.uuidString {
                return true
            }
        }
        return false
    }
    static func setReady(conversation: MSConversation, components: URLComponents) {
        for ( _, queryItem) in (components.queryItems?.enumerated())! {
            let name = queryItem.name
            if name == "ready" {
                _ready = queryItem.value == "true" ? true : false
            }
        }
        if isMyMessage(conversation) == false {
            _ready = true
        }
    }
    static func setScrambler(components: URLComponents) {
        _scrambler = [0,0,0,0,0,0,0,0,0]
        for ( _, queryItem) in (components.queryItems?.enumerated())! {
            let name = queryItem.name
            if name.contains("scb") {
                let c = name[String.Index.init(utf16Offset: 3, in: name)]
                let index = Int(String(c))!
                _scrambler[index] = Int(queryItem.value!)!
            }
        }
    }
    /*
    static func getOpponentKey(conversation: MSConversation, components: URLComponents) -> String {
        let myid = conversation.localParticipantIdentifier.uuidString
        var senderid: String!
        for ( _, queryItem) in (components.queryItems?.enumerated())! {
            let name = queryItem.name
            if name == "sender" {
                senderid = queryItem.value!
            }
        }
        var key: String!
        if senderid == myid {
            key = "op"
        }else{
            key = "me"
        }
        return key
    }*/
    static func setOpponent(conversation: MSConversation, components: URLComponents) {
        _opponent = [
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0]
        ]
        var score_key: String!
        var key: String!
        if isMyMessage(conversation) {
            score_key = "op_score"
            key = "opb"
        } else {
            score_key = "my_score"
            key = "meb"
        }
        for ( _, queryItem) in (components.queryItems?.enumerated())! {
            let name = queryItem.name
            if name.contains(key) {
                let c1 = name[String.Index.init(utf16Offset: 3, in: name)]
                let c2 = name[String.Index.init(utf16Offset: 4, in: name)]
                let i = Int(String(c1))!
                let j = Int(String(c2))!
                _opponent[i][j] = Int(queryItem.value!)!
            }
            if name == score_key {
                _op_score = Int(queryItem.value!)!
            }
        }
    }
    /*
    static func getMyKey(conversation: MSConversation, components: URLComponents) -> String {
        let myid = conversation.localParticipantIdentifier.uuidString
        var senderid: String!
        for ( _, queryItem) in (components.queryItems?.enumerated())! {
            let name = queryItem.name
            if name == "sender" {
                senderid = queryItem.value!
            }
        }
        var key: String!
        if senderid == myid {
            key = "me"
        }else{
            key = "op"
        }
        return key
    }*/
    static func setMe(conversation: MSConversation, components: URLComponents) {
        _me = [
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0]
        ]
        var score_key: String!
        var key: String!
        if isMyMessage(conversation) {
            score_key = "my_score"
            key = "meb"
        } else {
            score_key = "op_score"
            key = "opb"
        }
        for ( _, queryItem) in (components.queryItems?.enumerated())! {
            let name = queryItem.name
            if name.contains(key) {
                let c1 = name[String.Index.init(utf16Offset: 3, in: name)]
                let c2 = name[String.Index.init(utf16Offset: 4, in: name)]
                let i = Int(String(c1))!
                let j = Int(String(c2))!
                _me[i][j] = Int(queryItem.value!)!
            }
            if name == score_key {
                _my_score = Int(queryItem.value!)!
            }
        }
    }
    static func setData(conversation: MSConversation, components: URLComponents) {
        setReady(conversation: conversation, components: components)
        setScrambler(components: components)
        setOpponent(conversation:conversation, components: components)
        setMe(conversation:conversation, components: components)
    }
    static func sendUpdate() {
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        layout.caption = "QuikBlock play"
        message.layout = layout
        message.url = QuikBlock.getURLComponents().url

        MessagesViewController.messagesVC.activeConversation?.send(message, completionHandler: { error in
        })
    }
    static func checkWinner() -> Int {
        if  _scrambler[0] == _me[1][1] &&
            _scrambler[1] == _me[1][2] &&
            _scrambler[2] == _me[1][3] &&
            _scrambler[3] == _me[2][1] &&
            _scrambler[4] == _me[2][2] &&
            _scrambler[5] == _me[2][3] &&
            _scrambler[6] == _me[3][1] &&
            _scrambler[7] == _me[3][2] &&
            _scrambler[8] == _me[3][3] {
            return 1
        }
        if  _scrambler[0] == _opponent[1][1] &&
            _scrambler[1] == _opponent[1][2] &&
            _scrambler[2] == _opponent[1][3] &&
            _scrambler[3] == _opponent[2][1] &&
            _scrambler[4] == _opponent[2][2] &&
            _scrambler[5] == _opponent[2][3] &&
            _scrambler[6] == _opponent[3][1] &&
            _scrambler[7] == _opponent[3][2] &&
            _scrambler[8] == _opponent[3][3] {
            return -1
        }
        return 0
    }
}
