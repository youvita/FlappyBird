//
//  FBObstacleLayer.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/16/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import SpriteKit

private let kMarkerBuffer : CGFloat              = 200
private let kVerticalGap : CGFloat               = 90.0
private let kSpaceBetweenObstacleSets : CGFloat  = 180.0
private let kCollectableVerticalRange : Int      = 200
private let kCollectableClearance : CGFloat      = 50.0

class FBObstacleLayer: FBScrollingNode {
    var marker : CGFloat    = CGFloat()
    var floor : CGFloat     = CGFloat()
    var ceiling : CGFloat   = CGFloat()
    var delegate : FBCollectableProtocolDelegate!
   
    override init() {
        super.init()
        
        for i in 1...5 {
            self.createObjectForKey(kMountainUp).position = CGPointMake(-1000, 0)
            self.createObjectForKey(kMountainDown).position = CGPointMake(-1000, 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateWithTimeElapse(timeElapsed: NSTimeInterval) {
        super.updateWithTimeElapse(timeElapsed)
        
        if (self.scrolling && self.scene != nil) {
           var markerLocationInScene = self.convertPoint(CGPointMake(self.marker, 0), toNode: self.scene!)
            if markerLocationInScene.x - (self.scene!.size.width * self.scene!.anchorPoint.x) < self.scene!.size.width + kMarkerBuffer{
                self.addObstacleSet()
            }
        }
    }
    
    func addObstacleSet(){
        
//        // Get mountain nodes.
//        var mountainUp = self.getUnusedObjectForKey(kMountainUp) as SKSpriteNode
//        var mountainDown = self.getUnusedObjectForKey(kMountainDown) as SKSpriteNode
//        
//        // Calculate maximum variation.
//        var maxVariation = (mountainUp.size.height + mountainDown.size.height + kVerticalGap) - (self.ceiling - self.floor) as CGFloat
//        var yAdjustment = CGFloat(arc4random_uniform(UInt32(maxVariation))) as CGFloat
//        
//        // Postion mountain nodes.
//        mountainUp.position = CGPointMake(self.marker, self.floor + (mountainUp.size.height * 0.5) - yAdjustment)
//        mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + kVerticalGap)
//        
//        // Get collectable star node.
//        var collectable = self.getUnusedObjectForKey(kCollectableStar)
//        // Position collectable.
//        var midPoint = mountainUp.position.y + (mountainUp.size.height * 0.5) + (kVerticalGap * 0.5) as CGFloat
//        let ramdomPoint = midPoint + CGFloat(arc4random_uniform(UInt32(kCollectableVerticalRange)))
//        let rangePoint = CGFloat(kCollectableVerticalRange) * 0.5
//        var yPosition = ramdomPoint - rangePoint
//        yPosition = fmax(yPosition, self.floor + kCollectableClearance)
//        yPosition = fmin(yPosition, self.ceiling - kCollectableClearance)
//        collectable.position = CGPointMake(self.marker + (kSpaceBetweenObstacleSets * 0.5), yPosition)
        
        var challenge = FBChallengeProvider.getProvider().getRandomChallenges()
        var furthestItem : CGFloat = 0
        for item in challenge as! [FBChallengeItem] {
            var object = self.getUnusedObjectForKey(item.obstacleKey as String) as SKSpriteNode
            object.position = CGPointMake(item.position.x + self.marker, item.position.y)
            if (item.position.x > furthestItem) {
                furthestItem = item.position.x
            }
        }
        
        // Reposition marker
        self.marker += furthestItem+kSpaceBetweenObstacleSets
    }
    
    func createObjectForKey(key:String) -> SKSpriteNode {
        var object : SKSpriteNode!
        var graphicsAtlas = SKTextureAtlas(named: "Graphics")
        
        if key == kMountainUp || key == kMountainUpAlternate {
            //            object = SKSpriteNode(texture: graphicsAtlas.textureNamed("MountainGrass"))
            object = SKSpriteNode(texture: FBTilesetTextureProvider.sharedInstance().getTextureForKey(key))
            var offsetX = object.frame.size.width * object.anchorPoint.x as CGFloat
            var offsetY = object.frame.size.height * object.anchorPoint.y as CGFloat
            var path = CGPathCreateMutable() as CGMutablePathRef
            CGPathMoveToPoint(path, nil, 55 - offsetX, 199 - offsetY)
            CGPathAddLineToPoint(path, nil, 0 - offsetX, 0 - offsetY)
            CGPathAddLineToPoint(path, nil, 90 - offsetX, 0 - offsetY)
            CGPathCloseSubpath(path)
            
            object.physicsBody = SKPhysicsBody(edgeLoopFromPath:path)
            object.physicsBody?.categoryBitMask = kFBCategoryGround
            
            self.addChild(object)
        }else if key == kMountainDown || key == kMountainDownAlternate {
//            object = SKSpriteNode(texture: graphicsAtlas.textureNamed("MountainGrassDown"))
            object = SKSpriteNode(texture: FBTilesetTextureProvider.sharedInstance().getTextureForKey(key))
            var offsetX = object.frame.size.width * object.anchorPoint.x as CGFloat
            var offsetY = object.frame.size.height * object.anchorPoint.y as CGFloat
            var path = CGPathCreateMutable() as CGMutablePathRef
            CGPathMoveToPoint(path, nil, 0 - offsetX, 199 - offsetY)
            CGPathAddLineToPoint(path, nil, 55 - offsetX, 0 - offsetY)
            CGPathAddLineToPoint(path, nil, 90 - offsetX, 199 - offsetY)
            CGPathCloseSubpath(path)
            
            object.physicsBody = SKPhysicsBody(edgeLoopFromPath:path)
            object.physicsBody?.categoryBitMask = kFBCategoryGround
           
            self.addChild(object)
        }else if key == kCollectableStar {
            object = FBCollectable(texture: graphicsAtlas.textureNamed("starGold"))
            object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width * 0.3)
            object.physicsBody?.categoryBitMask = kFBCategoryCollectable
            object.physicsBody?.dynamic = false
            (object as! FBCollectable).pointValue = 1
            (object as! FBCollectable).delegate = self.delegate
            (object as! FBCollectable).soundCollect = Sound(named: "Collect.caf")
            
            self.addChild(object)
        }
        
        if object != 0 {
            object.name = key
        }
        
        return object
    }
    
    func getUnusedObjectForKey(key:String) -> SKSpriteNode {
        if self.scene != nil {
            // Get left edge of screen in local coordinates.
            var pointX = CGPointMake(-self.scene!.size.width * self.scene!.anchorPoint.x, 0)
            var leftEdgeInLocalCoords = self.scene?.convertPoint(pointX, toNode:self).x
            
            // Try find object for key to the left of the screen.
            for node in self.children as! [SKNode] {
                if (node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords) {
                    // Return unused object.
                    return node as! SKSpriteNode
                }
            }
        }
                
        return self.createObjectForKey(key)
    }
    
    func reset(){
        // Loop through child nodes and reposition for reuse.
        for node in self.children as! [SKNode] {
            node.position = CGPointMake(-1000, 0)
            
            if node.name == kMountainUp || node.name == kMountainDown || node.name == kMountainUpAlternate || node.name == kMountainDownAlternate {
                (node as! SKSpriteNode).texture = FBTilesetTextureProvider.sharedInstance().getTextureForKey(node.name!)
            }
        }
        // Reposition marker.
        if self.scene != nil {
            self.marker = self.scene!.size.width + kMarkerBuffer
        }
    }
}
