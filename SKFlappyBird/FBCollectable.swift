//
//  FBCollectable.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/17/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import SpriteKit

protocol FBCollectableProtocolDelegate{
    func wasCollected(collectable:FBCollectable)
}

class FBCollectable: SKSpriteNode {
   
    var delegate : FBCollectableProtocolDelegate?
    var pointValue : NSInteger!
    var soundCollect : Sound!
    
    func collect(){
        soundCollect.play()
        self.runAction(SKAction.removeFromParent())
        if (delegate != nil) {
            delegate?.wasCollected(self)
        }
    }
}
