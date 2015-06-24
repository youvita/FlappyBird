//
//  FBScrollingNode.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/15/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import SpriteKit

class FBScrollingNode: SKNode {
   
    var horizontalScrollSpeed : CGFloat = CGFloat() // Distance to scroll per second
    var scrolling : Bool                = Bool()
    
    func updateWithTimeElapse(timeElapsed:NSTimeInterval){
        if scrolling {
            let speedFrame = self.horizontalScrollSpeed * CGFloat(timeElapsed) as CGFloat
            self.position  = CGPointMake(self.position.x + speedFrame , self.position.y);
        }
    }
}
