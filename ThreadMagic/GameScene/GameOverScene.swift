//
//  GameOverScene.swift
//  ThreadMagic
//
//  Created by Steven Yang on 2/19/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameOverScene: SKScene {
    var mc: Player!
    let won: Bool
    var worldMapScene: SKScene!
    
    var audioPlayer:SKTAudio!
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
        
    }
    
    override func didMoveToView(view: SKView) {

        SKTAudio.sharedInstance().playBackgroundMusic("Victory Fanfare.mp3")
        backgroundColor = SKColor.whiteColor()
        
        let message = won ? "\(mc.charName) won!" : "You didn't make it, soorry!"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0), SKAction.runBlock() {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = self.worldMapScene
                self.view?.presentScene(scene, transition: reveal)
            }
        ]))
    
      
    
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}