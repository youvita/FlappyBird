//
//  FBWeatherLayer.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/23/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit
import SpriteKit

enum WEATHERTYPE {
    case CLEAR
    case RAINING
    case SNOWING
}

class FBWeatherLayer: SKNode {
   
    var rainEmitter : SKEmitterNode!
    var snowEmitter : SKEmitterNode!
    
    var soundRain : Sound!
    var size : CGSize!
    var condition : WEATHERTYPE!{
        didSet{
            if (condition != nil) {
                self.setWeatherCondition(condition)
            }
        }
    }
    
    init(size:CGSize) {
        super.init()
        
        // Load rain effect.
        var rainEffectPath = NSBundle.mainBundle().pathForResource("RainWeather", ofType: "sks")
        rainEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(rainEffectPath!) as! SKEmitterNode
        rainEmitter.position = CGPointMake(size.width * 0.5 + 32, size.height + 5)
        
        soundRain = Sound(named: "Rain.caf")
        soundRain.looping = true
        
        // Load snow effect.
        var snowEffectPath = NSBundle.mainBundle().pathForResource("SnowWeather", ofType: "sks")
        snowEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(snowEffectPath!) as! SKEmitterNode
        snowEmitter.position = CGPointMake(size.width * 0.5, size.height + 5)
        
    }
    
    func setWeatherCondition(conditions:WEATHERTYPE){
            // Remove existing weather effect.
            self.removeAllChildren()
                        // Stop any existing sounds from playing.
            if self.soundRain.playing {
                self.soundRain.fadeOut(1.0)
            }
        
            // Add weather conditions.
            switch (conditions) {
            case .RAINING:
                self.soundRain.play()
                self.soundRain.fadeIn(1.0)
                self.addChild(rainEmitter)
                self.rainEmitter.advanceSimulationTime(5)
                break
            case .SNOWING:
                self.addChild(snowEmitter)
                self.snowEmitter.advanceSimulationTime(5)
                break
            default:
                break
            }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
