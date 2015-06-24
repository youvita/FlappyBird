//
//  FBButton.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/22/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit
import SpriteKit

class FBButton: SKSpriteNode {
   
    var pressedScale : CGFloat!
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
//        self.pressedScale = 0.9
        self.userInteractionEnabled = true
     
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("Began")
//        touchesMoved(touches, withEvent: event)
    }
    
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        println("Moved")
//        for touch in (touches as! Set<UITouch>) {
//            if CGRectContainsPoint(self.frame, touch.locationInNode(self.parent)) {
//                self.setScale(self.pressedScale)
//            } else {
//                self.setScale(0.1)
//            }
//        }
//    }
//    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.setScale(0.1)
//        for touch in (touches as! Set<UITouch>) {
//            if CGRectContainsPoint(self.frame, touch.locationInNode(self.parent))
//            {
//                // Pressed button.
//                println("Ended")
//
//            }
//        }
//    }
//    
//    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
//         println("Cancelled")
//        self.setScale(0.1)
//    }
//    
//    func pressedPlay(){
//        println("pressed")
//
//    }
    
}
