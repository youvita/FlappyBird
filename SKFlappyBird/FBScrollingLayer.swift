//
//  FBScrollingLayer.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/15/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import SpriteKit

class FBScrollingLayer: FBScrollingNode {
   
    var rightmostTitle : SKSpriteNode!
    
    init(titleSpriteNodes: NSArray){
        super.init()

        for i in 0..<titleSpriteNodes.count {
            if let title = titleSpriteNodes[i] as? SKSpriteNode {
                title.anchorPoint = CGPointZero
                title.name = "Title"
                self.addChild(title)
            }
        }
        
        self.layoutTitles()
    }
    
    func layoutTitles(){
        self.rightmostTitle = SKSpriteNode()
        self.enumerateChildNodesWithName("Title", usingBlock:{
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            node.position = CGPointMake(self.rightmostTitle.position.x +
                self.rightmostTitle.size.width, node.position.y)
                self.rightmostTitle = node as! SKSpriteNode
        })
    }
    
    override func updateWithTimeElapse(timeElapsed: NSTimeInterval) {
        super.updateWithTimeElapse(timeElapsed)
        if (self.scrolling && self.horizontalScrollSpeed < 0 && self.scene != nil) {
            self.enumerateChildNodesWithName("Title", usingBlock:{
                (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
                var nodePositionInScene = self.convertPoint(node.position, toNode: self.scene!)
                let leftSide = nodePositionInScene.x + node.frame.size.width
                let rightSide = -(self.scene!.size.width) * self.scene!.anchorPoint.x
                if  leftSide < rightSide {
                    node.position = CGPointMake(self.rightmostTitle.position.x + self.rightmostTitle.size.width, node.position.y)
                    self.rightmostTitle = node as! SKSpriteNode
                }
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
