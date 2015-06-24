//
//  FBGameOverMenu.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/22/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import SpriteKit

enum MedalType {
    case MedalNone,MedalBronze,MedalSilver,MedalGold
}

class FBGameOverMenu: SKNode {
    var size : CGSize!
    var score : NSInteger!
    var bestScore : NSInteger!
    var medal : MedalType!
    
    init(size:CGSize) {
        super.init()
        self.size = size
        
        var atlas = SKTextureAtlas(named: "Graphics")
        var panelBackground = SKSpriteNode(texture: atlas.textureNamed("UIbg"))
        panelBackground.position = CGPointMake(size.width * 0.5, size.height - 150.0)
        panelBackground.centerRect = CGRectMake(10 / panelBackground.size.width,
        10 / panelBackground.size.height,
        (panelBackground.size.width - 20) / panelBackground.size.width,
        (panelBackground.size.height - 20) / panelBackground.size.height)
        panelBackground.xScale = 175.0 / panelBackground.size.width
        panelBackground.yScale = 155.0 / panelBackground.size.height
        self.addChild(panelBackground)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
