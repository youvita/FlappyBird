//
//  FBTilesetTextureProvider.swift
//  SKFlappyBird
//
//  Created by Chan Youvita on 6/19/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

import UIKit
import SpriteKit

class FBTilesetTextureProvider: NSObject {
   
    var tilesets : NSMutableDictionary!
    var currentTileset : NSDictionary!
    var currentTilesetName : NSString!
    
    class func sharedInstance() -> FBTilesetTextureProvider {
        struct Provider {
            static let instance = FBTilesetTextureProvider()
        }
        return Provider.instance
    }
    
    override init() {
        super.init()
        self.loadTilesets()
        self.randomTilesets()
    }
    
    func randomTilesets(){
        var tilesetKeys = self.tilesets.allKeys as NSArray
         println("key:--->\(tilesetKeys)")
        currentTilesetName = tilesetKeys.objectAtIndex(Int(arc4random_uniform(UInt32(tilesetKeys.count)))) as! NSString
        self.currentTileset = self.tilesets.objectForKey(currentTilesetName) as! NSDictionary
    }
    
    func getTextureForKey(key:String) -> SKTexture {
        return self.currentTileset.objectForKey(key) as! SKTexture
    }
    
    func loadTilesets(){
        self.tilesets = NSMutableDictionary()
        let atlas = SKTextureAtlas(named: "Graphics") as SKTextureAtlas
        
        // Get path to property list.
        let plistPath = NSBundle.mainBundle().pathForResource("TilesetGraphics", ofType: "plist")
        // Load contents of file.
        var tilesetList : NSDictionary = NSDictionary(contentsOfFile: plistPath!)!
        // Loop through tilesetList.
        for (key,value) in tilesetList {
            // Get dictionary of texture names.
            println("key:--->\(key) and value:--->\(value)")
            var textureList = tilesetList.objectForKey(key) as! NSDictionary
            // Create dictionary to hold textures.
            var textures = NSMutableDictionary()
            for (key,value) in textureList {
                // Get texture for key.
                var texture = atlas.textureNamed(textureList.objectForKey(key) as! String) as SKTexture
                // Insert texture to textures dictionary.
                textures.setObject(texture, forKey: key as! String)
            }
            
            // Add textures dictionary to tilesets.
            self.tilesets.setObject(textures, forKey: key as! String)
        }
    }
}
