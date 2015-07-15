//
//  FBReadyMenu.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/26/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit
import SpriteKit

class FBReadyMenu: SKNode {
   
    var readyTitle  : SKSpriteNode!
    var leftTap     : SKSpriteNode!
    var rightTap    : SKSpriteNode!
    var tapHand     : SKSpriteNode!
    var tapGroup    : SKNode!
    var size        : CGSize!
    var poistion    : CGPoint!
    
    init(size:CGSize,planePoistion:CGPoint) {
        super.init()
        self.size = size
        
        /* Create ready text */
        let graphicsAtlas = SKTextureAtlas(named: "Graphics")
        readyTitle = SKSpriteNode(texture: graphicsAtlas.textureNamed("textGetReady"))
        readyTitle.position = CGPointMake(size.width * 0.75, planePoistion.y)
        self.addChild(readyTitle)
        
        tapGroup = SKNode()
        tapGroup.position = planePoistion
        self.addChild(tapGroup)
        
        /* Create tap group */
        rightTap = SKSpriteNode(texture: graphicsAtlas.textureNamed("tapRight"))
        rightTap.position = CGPointMake(50, 0)
        self.tapGroup.addChild(rightTap)
        
        leftTap = SKSpriteNode(texture: graphicsAtlas.textureNamed("tapLeft"))
        leftTap.position = CGPointMake(-50, 0)
        self.tapGroup.addChild(leftTap)
        
        // Get frames for tap animation.
        var tapAnimationFrames = [graphicsAtlas.textureNamed("tap"),
                                graphicsAtlas.textureNamed("tapTick"),
                                graphicsAtlas.textureNamed("tapTick")]
        // Create action for tap animation
        var tapAnimation = SKAction.animateWithTextures(tapAnimationFrames, timePerFrame: 0.5, resize: true, restore: false)
        // Setup tap hand
        tapHand = SKSpriteNode(texture: graphicsAtlas.textureNamed("tap"))
        tapHand.position = CGPointMake(0, -40)
        self.tapGroup.addChild(tapHand)
        
        tapHand.runAction(SKAction.repeatActionForever(tapAnimation))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide(){
        // Create action to fade out tap group
        var fadeTapGroup = SKAction.fadeOutWithDuration(0.5)
        self.tapGroup.runAction(fadeTapGroup)
        // Create action to slide get ready text
        let slideLeft = SKAction.moveByX(-30, y: 0, duration: 0.2)
        slideLeft.timingMode = SKActionTimingMode.EaseInEaseOut
        let slideRight = SKAction.moveToX(self.size.width + (self.readyTitle.size.width), duration: 0.6)
        slideRight.timingMode = SKActionTimingMode.EaseIn
        // Slide get text off to the right
        self.readyTitle.runAction(SKAction.sequence([slideLeft,slideRight]))
        
    }
    
    func show(){
        // Reset node
        self.tapGroup.alpha = 1.0
        self.readyTitle.position = CGPointMake(self.size.width * 0.75, self.readyTitle.position.y)
    }
    
}
