//
//  FBChallengeProvider.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/20/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit
import SpriteKit

class FBChallengeItem: NSObject {
    
    var obstacleKey : NSString!
    var position : CGPoint!
    
    class func challengeItemWithKey(key:NSString,posistion:CGPoint) -> FBChallengeItem {
        var item = FBChallengeItem()
        item.obstacleKey = key
        item.position = posistion
        return item
    }

}

class FBChallengeProvider: NSObject {
    var challenges : NSMutableArray!
    
    class func getProvider() -> FBChallengeProvider {
        struct Provider {
            static let sharedInstance = FBChallengeProvider()
        }
        Provider.sharedInstance.loadChallenges()
        
        return Provider.sharedInstance
    }
    
    func loadChallenges(){
        challenges = NSMutableArray()
        // Challenge 1
        var challenge = NSMutableArray()
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kMountainUp, posistion: CGPointMake(0, 64)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kMountainDown, posistion: CGPointMake(143, 250)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kCollectableStar, posistion: CGPointMake(33, 180)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kCollectableStar, posistion: CGPointMake(101, 44)))
        self.challenges.addObject(challenge)
        
        // Challenge 2
        challenge = NSMutableArray()
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kMountainUp, posistion: CGPointMake(90, 25)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kMountainDownAlternate, posistion: CGPointMake(0, 232)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kCollectableStar, posistion: CGPointMake(100, 243)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kCollectableStar, posistion: CGPointMake(152, 205)))
        self.challenges.addObject(challenge)
        
        // Challenge 3
        challenge = NSMutableArray()
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kMountainUp, posistion: CGPointMake(0, 82)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kMountainUpAlternate, posistion: CGPointMake(122, 0)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kMountainDown, posistion: CGPointMake(85, 320)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kCollectableStar, posistion: CGPointMake(10, 213)))
        challenge.addObject(FBChallengeItem.challengeItemWithKey(kCollectableStar, posistion: CGPointMake(81, 116)))
        self.challenges.addObject(challenge)

    }
    
    func getRandomChallenges() -> NSArray {
        return self.challenges.objectAtIndex(Int(arc4random_uniform(UInt32(self.challenges.count)))) as! NSArray
    }

}
