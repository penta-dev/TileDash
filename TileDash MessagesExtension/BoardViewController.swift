//
//  BoardViewController.swift
//  TileDash MessagesExtension
//
//  Created by dev on 5/20/21.
//

import UIKit
import Messages

class BoardViewController: UIViewController {
    var _touchEnable = true
    var _messageVC: MessagesViewController!
    var _gameVC: GameViewController?
    
    var _value: [[Int]]!
    var _cell:[[UIImageView]]!
    var _cellSize: CGFloat!
    
    var _prevPos: CGPoint!
    enum Direction { case None, Up, Down, Right, Left }
    var _direction: Direction = .None
    var _moveCell: [(Int, Int)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustCellFrame()
    }
    func initCellViews() {
        // get ImageViews by tag
        _cell = []
        for i in stride(from: 1, to: 5+1, by: 1)
        {
            var views:[UIImageView] = []
            for j in stride(from: 0, to: 5, by: 1)
            {
                let tag = i*10 + j
                let imageView = view.viewWithTag(tag) as! UIImageView                
                views.append(imageView)
            }
            _cell.append(views)
        }
    }
    public func setBoard(_ value: [[Int]]) {
        _value = value
        refreshBoard()
    }
    private func adjustCellFrame() {
        _cellSize = (view.frame.width-4) / 5
        for i in stride(from: 0, to: 5, by: 1) {
            for j in stride(from: 0, to: 5, by: 1) {
                let pos = getScreenPos(i: i, j: j)
                _cell[i][j].frame = CGRect(x: pos.x, y: pos.y, width: _cellSize, height: _cellSize)
            }
        }
    }
    func refreshBoard() {
        for i in stride(from: 0, to: 5, by: 1) {
            for j in stride(from: 0, to: 5, by: 1) {
                _cell[i][j].image = TileDash.getImage(value: _value[i][j])
            }
        }
    }
    private func getCellIndex(from pos: CGPoint) -> (Int, Int) {
        for i in stride(from: 0, to: 5, by: 1) {
            for j in stride(from: 0, to: 5, by: 1) {
                if _cell[i][j].frame.contains(pos) {
                    return (i,j)
                }
            }
        }
        return (-1, -1)
    }
    private func getBlackPos() -> (Int, Int) {
        for i in stride(from: 0, to: 5, by: 1) {
            for j in stride(from: 0, to: 5, by: 1) {
                if _value[i][j] == -1 {
                    return (i, j)
                }
            }
        }
        assert(false, "Couldn't find the black title.")
        return (0, 0)
    }
    private func getScreenPos(i:Int, j:Int) -> CGPoint {
        return CGPoint(x: _cellSize*CGFloat(i) + 2, y: _cellSize*CGFloat(j) + 2)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !_touchEnable { return }
        
        _moveCell = []
        _direction = .None
        
        for touch in touches {
            _prevPos = touch.location(in: view)
            let (row, col) = getCellIndex(from: _prevPos)
            if row < 0 || col < 0 { return }
            let (bi, bj) = getBlackPos()
            
            if row == bi && col != bj {// vertical
                if col+1 == bj { // down
                    _direction = .Down
                    for y in stride(from: col, to: bj, by: 1) {
                        _moveCell.append((row, y))
                    }
                }
                if col == bj+1 { // up
                    _direction = .Up
                    for y in stride(from: col, to: bj, by: -1) {
                        _moveCell.append((row, y))
                    }
                }
            }
            if row != bi && col == bj {// horizontal
                if row+1 == bi { // right
                    _direction = .Right
                    for x in stride(from: row, to: bi, by: 1) {
                        _moveCell.append((x, col))
                    }
                }
                if row == bi+1 { // left
                    _direction = .Left
                    for x in stride(from: row, to: bi, by: -1) {
                        _moveCell.append((x, col))
                    }
                }
            }            
            break
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !_touchEnable { return }
        
        for touch in touches {
            let pos = touch.location(in: view) as CGPoint
            
            var dx = pos.x - _prevPos.x
            var dy = pos.y - _prevPos.y
            
            switch _direction {
            case .Right:
                dy = 0
                if dx < 0 { dx = 0 }
                if dx > _cellSize { dx = _cellSize}
                break
            case .Left:
                dy = 0
                if dx < -_cellSize { dx = -_cellSize}
                if dx > 0 { dx = 0 }
                break
            case .Up:
                dx = 0
                if dy < -_cellSize { dy = -_cellSize }
                if dy > 0 { dy = 0 }
                break
            case .Down:
                dx = 0
                if dy < 0 { dy = 0 }
                if dy > _cellSize { dy = _cellSize }
                break
            default:
                break
            }
            for (i, j) in _moveCell {
                let screenPos = getScreenPos(i: i, j: j)
                _cell[i][j].frame = CGRect(x: screenPos.x + dx, y: screenPos.y + dy, width: _cellSize, height: _cellSize)
            }
            
            break
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !_touchEnable { return }
        
        touchesEnded(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !_touchEnable { return }
        for _ in touches {
            if _direction == .None {
                return
            }
            let (bi, bj) = getBlackPos()
            var prev = _value[bi][bj]
            for (i, j) in _moveCell {
                let tmp = _value[i][j]
                _value[i][j] = prev
                prev = tmp
            }
            _value[bi][bj] = prev
            
            refreshBoard()
            adjustCellFrame()
            didMove()
            
            break
        }
    }
    func didMove() {
        TileDash._my_score += 1
        _gameVC?.updateScore()
        
        TileDash._me = _value
        
        TileDash.sendUpdate()
        MessagesViewController.messagesVC.checkWinner()
    }
}
