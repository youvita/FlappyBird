//
//  FBGameScene.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/12/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import SpriteKit

private let kMinFPS : CGFloat = 10.0 / 60.0

enum GameState {
    case GAMEREADY
    case GAMERUNNING
    case GAMEOVER
}

class FBGameScene: SKScene , SKPhysicsContactDelegate , FBCollectableProtocolDelegate , FBPlaneDelegate{
    var mainLayerGame      : SKNode = SKNode()
    var player             : FBPlane = FBPlane()
    var background         : FBScrollingLayer!
    var foreground         : FBScrollingLayer!
    var obstacles          : FBObstacleLayer!
    var scoreLabel         : FBBitmapFontLabel!
    var gameOverMenu       : FBGameOverMenu!
    var weather            : FBWeatherLayer!
    var readyMenu          : FBReadyMenu!
    var gameState          : GameState!
    var bumpEffect         : SKEmitterNode!
    var scoreValue : Int = 0
    var score : Int {
        get{
            return scoreValue
        }
        set{
            if newValue >= 0 {
                println("\(newValue)")
                scoreValue = newValue
                scoreLabel.text = "\(scoreValue)"
            }
        }
    }
    
    var lastCallTime : NSTimeInterval = NSTimeInterval()
  
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsWorld.gravity         = CGVectorMake(0.0, -4.0)
        self.physicsWorld.contactDelegate = self
        
        mainLayerGame = SKNode()
        self.addChild(mainLayerGame)
        
        // Set background color to sky blue.
        self.backgroundColor = SKColor(red:0.835294118, green:0.929411765, blue:0.968627451, alpha:1.0)
        
        let graphicAtlas = SKTextureAtlas(named: "Graphics")
        var backgroundTitles = NSMutableArray()
        for (var i = 0; i < 3; i++){
            var sprite = SKSpriteNode(texture: graphicAtlas.textureNamed("background"))
            backgroundTitles.addObject(sprite)
        }
        
        background = FBScrollingLayer(titleSpriteNodes: backgroundTitles)
        background.horizontalScrollSpeed = -60
        background.scrolling = true
        mainLayerGame.addChild(background)
        
        /* Setup Player Game */
        player                                = FBPlane()
        player.physicsBody?.affectedByGravity = false
        mainLayerGame.addChild(player)
        
        /* Setup Obstacle Layer */
        obstacles = FBObstacleLayer()
        obstacles.horizontalScrollSpeed = -80
        obstacles.scrolling = true
        obstacles.floor = 0.0
        obstacles.ceiling = self.size.height
        obstacles.delegate = self
        mainLayerGame.addChild(obstacles)
        
        /* Setup ground tile */
        foreground = FBScrollingLayer(titleSpriteNodes:[
            self.generateGroundTile(),
            self.generateGroundTile(),
            self.generateGroundTile()])
        
        foreground.horizontalScrollSpeed = -80
        foreground.scrolling = true
        mainLayerGame.addChild(foreground)
        
        /* Setup score */
        scoreLabel = FBBitmapFontLabel(text: "0", fontName: "number")
        scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100)
        self.addChild(scoreLabel)
        
//        /* Setup game over */
//        gameOverMenu = FBGameOverMenu(size: size)
//        self.addChild(gameOverMenu)
        
        /* Setup weather */
        weather = FBWeatherLayer(size: size)
        self.addChild(weather)
        
        /* Start new game */
        self.newGame()
        
//        /* Setup button play */
//        let button = FBButton(texture: graphicAtlas.textureNamed("buttonPlay"))
//        button.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
//        mainLayerGame.addChild(button)
        
        /* Setup sound */
//        SoundManager.sharedManager().prepareToPlayWithSound("Crunch.caf")
        
        
        /* Setup ready menu */
        readyMenu = FBReadyMenu(size: size, planePoistion: CGPointMake(self.size.width * 0.3, self.size.height * 0.5))
        self.addChild(readyMenu)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: NSTimeInterval) {
        player.update()
        
        var timeElapse : NSTimeInterval = currentTime - lastCallTime
        if timeElapse > NSTimeInterval(kMinFPS) {
            timeElapse = NSTimeInterval(kMinFPS)
        }
        
        lastCallTime = currentTime
        
        if !player.isCrashed {
            /* run every time */
            background.updateWithTimeElapse(timeElapse)
            foreground.updateWithTimeElapse(timeElapse)
            obstacles.updateWithTimeElapse(timeElapse)
        }
//            else{
//            self.setBump()
//        }
    }
    
    // MARK: - FBCollectableDelegate
    func wasCollected(collectable: FBCollectable) {
        self.score += collectable.pointValue * 5
        self.scoreLabel.hidden = false
    }
    
    // MARK: - SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        player.delegate = self
        if contact.bodyA.categoryBitMask == kFBCategoryPlane {
            println("A")
            self.player.setCollided(contact.bodyB)
        }else if contact.bodyB.categoryBitMask == kFBCategoryPlane {
            println("B")
            self.player.setCollided(contact.bodyA)
        }
        
    }
    
    // MARK: - Touches Delegate
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
//            player.isEngineRunning = !player.isEngineRunning
//            player.setRandomColor()
            
            if player.isCrashed {
                newGame()
                bumpEffect.removeFromParent()
            }else{
                if self.gameState == GameState.GAMEREADY {
                    self.readyMenu.hide()
                    self.scoreLabel.hidden = true
//                    player.setFlap()
                    player.physicsBody?.affectedByGravity = true
                    obstacles.scrolling                   = true
                    self.gameState = GameState.GAMERUNNING
                }
                
                if self.gameState == GameState.GAMERUNNING {
                     player.isAccelerating                 = true
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>){
            if self.gameState == GameState.GAMERUNNING {
                player.isAccelerating = false
            }
        }
        
    }
    
    // MARK: - FBPlane Delegate
    func didCrash() {
        println("true")
        self.setBump() // set background crash
        
//         println("\(player.position)")
//        let bumpPath = NSBundle.mainBundle().pathForResource("PlaneBump", ofType: "sks")
//        bumpEffect = NSKeyedUnarchiver.unarchiveObjectWithFile(bumpPath!) as! SKEmitterNode
////        bumpEffect.position = player.position
//        player.addChild(bumpEffect)
        
//        self.newGame()
//        self.readyMenu.show()
//        player.position                       = CGPointMake(self.size.width * 0.3, self.size.height * 0.5)
//        player.physicsBody?.affectedByGravity = true
    }
    
    // MARK: - Method Implement
    func generateGroundTile() -> SKSpriteNode {
        let graphicAtlas = SKTextureAtlas(named: "Graphics")
        var sprite = SKSpriteNode(texture: graphicAtlas.textureNamed("groundGrass"))
        sprite.anchorPoint = CGPointZero
        
        var offsetX = sprite.frame.size.width * sprite.anchorPoint.x as CGFloat
        var offsetY = sprite.frame.size.height * sprite.anchorPoint.y as CGFloat
        
        var path = CGPathCreateMutable() as CGMutablePathRef
        CGPathMoveToPoint(path, nil, 403 - offsetX, 15 - offsetY)
        CGPathAddLineToPoint(path, nil, 367 - offsetX, 35 - offsetY)
        CGPathAddLineToPoint(path, nil, 329 - offsetX, 34 - offsetY)
        CGPathAddLineToPoint(path, nil, 287 - offsetX, 7 - offsetY)
        CGPathAddLineToPoint(path, nil, 235 - offsetX, 11 - offsetY)
        CGPathAddLineToPoint(path, nil, 205 - offsetX, 28 - offsetY)
        CGPathAddLineToPoint(path, nil, 168 - offsetX, 20 - offsetY)
        CGPathAddLineToPoint(path, nil, 122 - offsetX, 33 - offsetY)
        CGPathAddLineToPoint(path, nil, 76 - offsetX, 31 - offsetY)
        CGPathAddLineToPoint(path, nil, 46 - offsetX, 11 - offsetY)
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 16 - offsetY)
        
        sprite.physicsBody = SKPhysicsBody(edgeChainFromPath: path)
        sprite.physicsBody?.categoryBitMask = kFBCategoryGround
        
        return sprite
    }
    
    func newGame(){
        /* Random obstacle mountain, foreground again */
        FBTilesetTextureProvider.sharedInstance().randomTilesets()
        
        //////////////////////////////////////////////////////////////////////////////
        // Set weather conditions.
        var tilesetName = FBTilesetTextureProvider.sharedInstance().currentTilesetName
        self.weather.condition = WEATHERTYPE.CLEAR
        if tilesetName == kFBTilesetIce || tilesetName == kFBTilesetSnow {
            // 1 in 2 chance for snow on snow and ice tilesets.
            if (arc4random_uniform(2) == 0) {
                self.weather.condition = WEATHERTYPE.SNOWING
            }
        }
        
        if tilesetName == kFBTilesetGrass || tilesetName == kFBTilesetDirt {
            // 1 in 3 chance for rain on dirt and grass tilesets.
            if (arc4random_uniform(3) == 0) {
                self.weather.condition = WEATHERTYPE.RAINING
            }
        }
        //////////////////////////////////////////////////////////////////////////////
        
        /* Reset background */
        background.position = CGPointZero
        background.layoutTitles()
        
        /* Reset foreground */
        foreground.position = CGPointZero
        foreground.layoutTitles()
       
        /* Get foreground follow obstacle mountain */
        for node in foreground.children as! [SKSpriteNode]{
            node.texture = FBTilesetTextureProvider.sharedInstance().getTextureForKey("ground")
        }
        
        /* Reset obstacles mountain */
        obstacles.position  = CGPointZero
        obstacles.reset()
        obstacles.scrolling = false
    
        /* Reset player game */
        player.position                       = CGPointMake(self.size.width * 0.3, self.size.height * 0.5)
        player.physicsBody?.affectedByGravity = false
        player.reset()
        
        self.score = 0
        self.gameState = GameState.GAMEREADY
        
    }
    
    func setBump(){
        var bump = SKAction.sequence([
            SKAction.moveBy(CGVectorMake(-5, -4), duration: 0.1),
            SKAction.moveTo(CGPointZero, duration: 0.1)
            ])
        mainLayerGame.runAction(bump)
    }
    
    

}
