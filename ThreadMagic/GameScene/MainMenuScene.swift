//
//  MainMenu.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/26/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
    self.addBG("Title.png")
    self.scaleMode = .Fill

        
        let button1 = SKSpriteNode(imageNamed: "startButton")
        button1.setScale(0.7)
        button1.position = CGPoint(x: 1117, y: 320)
        button1.name = "StartNewGame"
        button1.runAction(SKAction.fadeInWithDuration(1))
        button1.alpha = 0
        
        let button2 = SKSpriteNode(imageNamed: "continueButton")
        button2.setScale(0.7)
        button2.position = CGPoint(x: 1117, y: 230)
        button2.name = "Continue"
        button2.runAction(SKAction.fadeInWithDuration(1))
        button2.alpha = 0
        
        let button3 = SKSpriteNode(imageNamed: "creditsButton")
        button3.setScale(0.7)
        button3.position = CGPoint(x: 1117, y: 140)
        button3.name = "Credit"
        button3.runAction(SKAction.fadeInWithDuration(1))
        button3.alpha = 0
        
        self.addChild(button1)
        self.addChild(button2)
        self.addChild(button3)
        
        SKTAudio.sharedInstance().playBackgroundMusic("Good Memories.mp3")
        
        print(button1.frame)
        print(button2.frame)
        print(button3.frame)
        
    }
    
    func addBG(backgroundName: String) {
        let bg = SKSpriteNode(imageNamed: backgroundName)
        bg.name = "bg"
        bg.zPosition = -1
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(bg)
    }

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        SKTAudio.sharedInstance().fadeVolumeAndPause()
        
        let touch = touches.first
        let positionInScene = touch!.locationInNode(self)

        let touchedNode = self.nodeAtPoint(positionInScene)
        print(positionInScene)
        
        
        if let name = touchedNode.name {

        if name == "StartNewGame" {
            let transition = SKTransition.crossFadeWithDuration(1)
            let scene = StoryScene(size:CGSize(width: 1280, height: 800))
            self.scene!.view?.presentScene(scene, transition: transition)
        }
        
        else if name == "Credit" {
            let transition = SKTransition.crossFadeWithDuration(1)
            let scene2 = CreditScene(size:CGSize(width: 1280, height: 800))
            self.scene!.view?.presentScene(scene2, transition: transition)
        }
    }
}
}