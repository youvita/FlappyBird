//
//  FBPlane.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/12/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import SpriteKit

private let kPlaneAnimation : String = "PlaneAnimation"
private let kMaxAltitude : CGFloat   = 300.0

class FBPlane: SKSpriteNode {
   
    let defaultTexture : SKTexture       = SKTexture(imageNamed: "planeBlue1")
    var animationPlanes : NSMutableArray = NSMutableArray()
    
    var puffTrailEmitter : SKEmitterNode = SKEmitterNode()
    var puffTrailBirthRate : CGFloat     = CGFloat()
//    var isAccelerating : Bool            = Bool()
    var crashTintAction : SKAction = SKAction()
    var engineSound : Sound!
    
    var isEngineRunning : Bool = false {
        didSet{
            if isEngineRunning && !isCrashed {
                self.engineSound.play()
                self.engineSound.fadeIn(1.0)
                self.actionForKey(kPlaneAnimation)?.speed = 1
                puffTrailEmitter.particleBirthRate = puffTrailBirthRate
                puffTrailEmitter.targetNode        = self.parent
            }else{
                self.engineSound.fadeOut(0.5)
                self.actionForKey(kPlaneAnimation)?.speed = 0
                puffTrailEmitter.particleBirthRate = 0
            }
        }
    }
    
    var isCrashed : Bool = false {
        didSet{
            if isCrashed {
                isEngineRunning = false
//                isAccelerating = false
            }
        }
    }
    
    init(){
        super.init(texture: defaultTexture, color: nil, size: defaultTexture.size())
        
        /* Setup physics body with path */
        var offsetX = self.frame.size.width * self.anchorPoint.x as CGFloat
        var offsetY = self.frame.size.height * self.anchorPoint.y as CGFloat
        
        var path = CGPathCreateMutable() as CGMutablePathRef
        
        CGPathMoveToPoint(path, nil, 42 - offsetX, 26 - offsetY)
        CGPathAddLineToPoint(path, nil, 34 - offsetX, 35 - offsetY)
        CGPathAddLineToPoint(path, nil, 11 - offsetX, 36 - offsetY)
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 27 - offsetY)
        CGPathAddLineToPoint(path, nil, 10 - offsetX, 4 - offsetY)
        CGPathAddLineToPoint(path, nil, 28 - offsetX, 0 - offsetY)
        CGPathAddLineToPoint(path, nil, 42 - offsetX, 4 - offsetY)
        CGPathCloseSubpath(path)
        
        self.physicsBody = SKPhysicsBody(polygonFromPath: path)
        self.physicsBody?.mass = 0.08
        self.physicsBody?.categoryBitMask       = kFBCategoryPlane
        self.physicsBody?.contactTestBitMask    = kFBCategoryGround | kFBCategoryCollectable
        self.physicsBody?.collisionBitMask      = kFBCategoryGround
        
        let animationPlistPath = NSBundle.mainBundle().pathForResource("PlaneAnimations", ofType: "plist")
        let animations = NSDictionary(contentsOfFile: animationPlistPath!)
        for key: AnyObject in (animations!.allKeys as NSArray) {
            let action = self.animationFromArray(animations!.objectForKey(key) as! NSArray, duration: 0.4)
            animationPlanes.addObject(action)
        }
        
        /* Setup puff trail particles */
        let particleFile = NSBundle.mainBundle().pathForResource("PlanePuffTrail", ofType: "sks")
        puffTrailEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(particleFile!) as! SKEmitterNode
        puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, 5)
        self.addChild(puffTrailEmitter)
        puffTrailBirthRate =  puffTrailEmitter.particleBirthRate // particle birthrate of file default 6
        puffTrailEmitter.particleBirthRate = 0 // make puff trail no has
        
        // Setup action to tint plane when it crashes.
        var tint = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.8, duration: 0.0)
        var removeTint = SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.2)
        crashTintAction = SKAction.sequence([tint,removeTint])

        /* Sound */
        engineSound = Sound(named: "Engine.caf")
        engineSound.looping = true
        
        self.setRandomColor()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRandomColor(){
        self.removeActionForKey(kPlaneAnimation)
        let animation = self.animationPlanes.objectAtIndex(Int(arc4random_uniform(UInt32(self.animationPlanes.count)))) as! SKAction
        self.runAction(animation, withKey: kPlaneAnimation)
        
        if !isEngineRunning {
            self.actionForKey(kPlaneAnimation)?.speed = 0
        }
    }
    
    func setFlap(){
        if !isCrashed && self.position.y < kMaxAltitude {
            self.physicsBody?.applyImpulse(CGVectorMake(0,20))
            
            // Make sure plane can't drop faster than -200.
            if (self.physicsBody?.velocity.dy < -200) {
                self.physicsBody?.velocity = CGVectorMake(0, -200)
            }
            
            // Make sure that the plane can't go up faster than 300.
            if (self.physicsBody?.velocity.dy > 300) {
                self.physicsBody?.velocity = CGVectorMake(0, 300)
            }
        }
    }
    
    func animationFromArray(textureNames:NSArray, duration:CGFloat) -> SKAction {
        // Create array to hold textures
        let planeAtlas = SKTextureAtlas(named: "Graphics")
        var frames = NSMutableArray()
        
        for textureName in textureNames {
            frames.addObject(planeAtlas.textureNamed(textureName as! String))
        }
        
        // Calculate time per frame.
        let frameTime : CGFloat = duration / CGFloat(frames.count)
        var time = NSTimeInterval(frameTime)
        
        // Create and return animation action
        let animateTexture : SKAction = SKAction.animateWithTextures(frames as [AnyObject], timePerFrame: time)
        return SKAction.repeatActionForever(animateTexture)
        
    }
    
    func update(){
//        if isAccelerating && !isCrashed && self.position.y < kMaxAltitude {
//            self.physicsBody?.applyForce(CGVectorMake(0.0, 100))
//        }
        
        /* Make plane roate up and down */
        if !isCrashed {
            var minValue = fminf(Float(self.physicsBody!.velocity.dy), 400) as Float
            var maxValue = fmaxf(minValue, -400) as Float
            self.zRotation =  CGFloat(maxValue / 400)
            
            /* Setup sound louder */
            var lounderMinValue = fminf(Float(self.physicsBody!.velocity.dy), 300)
            var lounderMaxValue = fmaxf(lounderMinValue, 0.0)
            var louderValue = lounderMaxValue / 300 * 0.75
            self.engineSound.volume = 0.25 + louderValue
        }
    }
    
    func setCollided(body:SKPhysicsBody){
        if !isCrashed {
            if body.categoryBitMask == kFBCategoryGround {
                println("hied")
                // Hied Ground
                isCrashed = true
                self.runAction(crashTintAction)
                SoundManager.sharedManager().playSound("Crunch.caf")
            
            }
            if body.categoryBitMask == kFBCategoryCollectable {
                println("hied star")
//                body.node?.runAction(SKAction.removeFromParent())
                (body.node as! FBCollectable).collect()
            }
        }
    }
    
    
    func reset(){
        self.isCrashed                      = false
        self.isEngineRunning                = true
        self.physicsBody?.velocity          = CGVectorMake(0.0,0.0)
        self.physicsBody?.angularVelocity   = 0.0
        self.zRotation                      = 0.0
        self.setRandomColor()
    }
    
}
