//
//  NextLevelScene.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 01/03/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//


import SpriteKit
import AVFoundation

class NextLevelScene: SKScene {
    var mapLevel: MapLevel!
    
    var audioPlayer:SKTAudio!

    
    override func didMoveToView(view: SKView) {
        
        SKTAudio.sharedInstance().playBackgroundMusic("Victory Fanfare.mp3")
        backgroundColor = SKColor.blackColor()
        
        let message = "Proceeding to the next level!"
        
        let label = SKLabelNode(fontNamed: "Papyrus")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0), SKAction.runBlock() {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let nextLevel = MapLevel(rawValue: self.mapLevel.rawValue + 1)!
                let scene = WorldMapScene(size: self.size, mapLevel: nextLevel)
                self.view?.presentScene(scene, transition: reveal)
            }
            ])
        )
    }
    
}
