//
//  StoryScene.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/29/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import UIKit
import SpriteKit

class StoryScene: SKScene {
    
    var mc: Player!
    
    override func didMoveToView(view: SKView) {
        
        SKTAudio.sharedInstance().playBackgroundMusic("Remember.mp3")
        
        let bgImage = SKSpriteNode(imageNamed: "Parchment")
        
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        bgImage.runAction(SKAction.fadeInWithDuration(1))
        
        self.addChild(bgImage)
        
        
        /////
        
        //code for story text to appear line by line
        
        /////
        
        let button1 = SKSpriteNode(imageNamed: "Continue")
        button1.setScale(0.8)
        button1.position = CGPoint(x: 400, y: -223)
        button1.name = "Continue"
        button1.alpha = 0
        button1.runAction(SKAction.fadeInWithDuration(3))
        button1.zPosition = 1
        
        bgImage.addChild(button1)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        SKTAudio.sharedInstance().fadeVolumeAndPause()
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        let scene = WorldMapScene(size:CGSize(width: 1280, height: 800), mapLevel: MapLevel.levelOne)
        if (node.name == "Continue") {
            let transition = SKTransition.crossFadeWithDuration(2)
            self.scene!.view?.presentScene(scene, transition: transition)
        }
    }

}
