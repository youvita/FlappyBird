//
//  FBBitmapFontLabel.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/19/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit
import SpriteKit

class FBBitmapFontLabel: SKNode {
   
    var fontName : NSString! {
        didSet{
            if fontName != nil {
                self.updateText()
            }
        }
    }
    var text : NSString! {
        didSet{
            if text != nil{
                self.updateText()
            }
        }
    }
    var letterSpacing : CGFloat! {
        didSet{
            if letterSpacing != nil {
                self.updateText()
            }
        }
    }
    
    init(text:NSString,fontName:NSString) {
        super.init()
        self.text = text
        self.fontName = fontName
        self.letterSpacing = 2
        self.updateText()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(){
        // Remove unused nodes.
        if self.text.length < self.children.count {
            for (var i = self.children.count; i > self.text.length; i--) {
//                [[self.children objectAtIndex:i-1] removeFromParent]; // objective c
               (self.children as AnyObject).objectAtIndex(i-1).removeFromParent()
            }
        }
        
        var pos = CGPointZero as CGPoint
        var totalSize = CGSizeZero as CGSize
        var atlas = SKTextureAtlas(named:"Graphics")
   
        // Objective C
        //        for (NSUInteger i = 0; i < self.text.length; i++) {
        //            // Get character in text for current position in loop.
        //            unichar c = [self.text characterAtIndex:i];
        //        }
        

        // Loop through all characters in text.
        for i in 0..<self.text.length {
            var c = self.text.characterAtIndex(i) as unichar
            
            // Build texture name from character and font name.
            println("----> \(Character(UnicodeScalar(c)))") // ASCII convert Dec to Char 48 -> 0
           
            var textureName = "\(self.fontName)" + (String(Character(UnicodeScalar(c))))
            
            var letter = SKSpriteNode()
            if i < self.children.count {
                // Reuse an existing node.
                letter = (self.children as AnyObject).objectAtIndex(i) as! SKSpriteNode
                letter.texture = atlas.textureNamed(textureName)
                letter.size = letter.texture!.size()
            } else {
                // Create a new letter node.
                letter = SKSpriteNode(texture: atlas.textureNamed(textureName))
                letter.anchorPoint = CGPointZero
                self.addChild(letter)
            }
            
            letter.position = pos
            pos.x += letter.size.width + self.letterSpacing
            totalSize.width += letter.size.width + self.letterSpacing
            if totalSize.height < letter.size.height {
                totalSize.height = letter.size.height
            }

        }
        
        if self.text.length > 0 {
            totalSize.width -= self.letterSpacing
        }
        
        // Center text.
        var adjustment = CGPointMake(-totalSize.width * 0.5, -totalSize.height * 0.5) as CGPoint
        for letter in self.children as! [SKNode] {
            letter.position = CGPointMake(letter.position.x + adjustment.x, letter.position.y + adjustment.y)
        }
        
        
    }
}
