//
//  DanmakuScene.swift
//  Danmaku
//
//  Created by xjbeta on 1/3/22.
//

import Cocoa
import SpriteKit


class DanmakuScene: SKScene {
    
    let test = ["怎么这么菜啊", "233333", "芜湖~~~", "66666", "niconiconi", "哈哈哈哈哈哈哈哈哈哈哈", "啊", "~~~~~~", "``````", "--------"]
    
    let defaultDuration = 20
    
    override func sceneDidLoad() {
        
        view?.showsFPS = true
        
//        backgroundColor = .white
        
        scaleMode = .resizeFill
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
//        physicsWorld.gravity = .init(dx: -10, dy: 0)
        
        
    }
    

    override func didChangeSize(_ oldSize: CGSize) {
        print(#function, size)
        
        
    }
    
    
    override func mouseDown(with event: NSEvent) {
        
        test.forEach {
            sendDM($0)
        }
        
    }
    

    
    func sendDM(_ text: String) {
        
        let node = SKLabelNode()
        

        setNodeStyle(node, text: text)
        
        
        
        // Init Position
        let pos = findStartPosition(node)
        node.position = pos
        addChild(node)
        
        // Move and Remove
        let move = SKAction.moveTo(x: -node.frame.width, duration: .init(defaultDuration))
        let del = SKAction.removeFromParent()
        let act = SKAction.sequence([move, del])
        node.run(act)
    }
    
    func setNodeStyle(_ node: SKLabelNode, text: String) {
        let fontSize = 22.5
    
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2
//        shadow.shadowOffset = CGSize(width: 0, height: 0)
//        shadow.shadowColor = .black

        let defaultAttributes: [NSAttributedString.Key : Any] =
        [
            .font: NSFont.systemFont(ofSize: fontSize),
            .foregroundColor: NSColor.white,
//            .strokeColor: NSColor.black,
//            .strokeWidth: -2 * 3,
            
                .shadow: shadow,
        ]
        
        
        node.attributedText = NSAttributedString(string: text, attributes: defaultAttributes)
        

    }
    
    
    
    
    func findStartPosition(_ node: SKNode) -> CGPoint {
        let frame = node.frame
        let startX = size.width - frame.origin.x
        
        let width = size.width
        
        let newS = width
        let newV = (width + frame.width) / CGFloat(defaultDuration)
        let newT = newS / newV
        
        var nodeIntervals = children.filter { node -> Bool in
            let nodeS = node.position.x + node.frame.width
            let isEntering = nodeS > width
            
            if isEntering {
                // Skip overlay calculation
                return true
            }
            
            let nodeV = (node.frame.width + width) / CGFloat(defaultDuration)
            let nodeT = nodeS / nodeV
            
            let willCover = nodeV < newV && nodeT > newT
            return willCover
        }.map {
            (start: $0.frame.origin.y,
             end: $0.frame.origin.y + $0.frame.height)
        }
        
        nodeIntervals = mergeIntervals(nodeIntervals).sorted { i0, i1 in
            i0.0 > i1.0
        }
    
        let nodeHeight = frame.height
        
        var top = size.height
        var stop = false
        var nlIndex = 0
        
        let minY = nodeHeight + frame.origin.y
        
        
        var shouldDrop = false
        
        while top >= minY && !stop {
            if nlIndex < nodeIntervals.count {
                let cn = nodeIntervals[nlIndex]
                let space = top - cn.end
                
                if space >= minY {
                    // Find enough space
                    stop = true
                } else {
                    // Check next node
                    top = cn.start
                    nlIndex += 1
                }
            } else {
                // Not find next node
                stop = true
            }
        }
        
        if top < minY {
            shouldDrop = true
        }
        
        if shouldDrop {
            top = size.height
        }
        
        let startY = top - minY
        
        return .init(x: startX, y: startY)
    }
    
    
    func mergeIntervals(_ itv: [(CGFloat, CGFloat)]) -> [(CGFloat, CGFloat)] {
        var intervals = itv
        if intervals.count <= 1 {
            return intervals
        }
        intervals.sort { (elm1, elm2) -> Bool in
            let e1 = elm1
            let e2 = elm2
            return e1.0 <= e2.0
        }
        var res = [(CGFloat, CGFloat)]()
        var start = intervals[0].0
        var end = intervals[0].1
        
        for i in intervals {
            if i.0 <= end {
                end = max(end, i.1)
            } else {
                res.append((start, end))
                start = i.0
                end = i.1
            }
        }
        
        res.append((start, end))
        return res
    }
}
