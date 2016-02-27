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
        //self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        let button1 = SKSpriteNode(imageNamed: "StartNewGame")
        button1.setScale(0.8)
        button1.position = CGPoint(x: 482, y: 220)
        button1.name = "StartNewGame"
        
        self.addChild(button1)
        
        let button2 = SKSpriteNode(imageNamed: "Continue")
        button2.setScale(0.8)
        button2.position = CGPoint(x: 798, y: 220)
        button2.name = "Continue"
        
        self.addChild(button2)
        
        let button3 = SKSpriteNode(imageNamed: "Credit")
        button3.setScale(0.8)
        button3.position = CGPoint(x: 635, y: 128)
        button3.name = "Credit"
        
        self.addChild(button3)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //var touch = touches as! Set<UITouch>
        //var location = touch.first!.locationInNode(self)
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        // If next button is touched, start transition to second scene
        
        let scene = GameScene(size:CGSize(width: 1280, height: 800))
        if (node.name == "StartNewGame") {
            let transition = SKTransition.crossFadeWithDuration(4)
            self.scene!.view?.presentScene(scene, transition: transition)
        }
    }
}