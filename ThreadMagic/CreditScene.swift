//
//  CreditScene.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 3/2/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import UIKit

class CreditScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()
        
        let tyMessage = "Thanks for playing!"
        
        let tyLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        tyLabel.text = tyMessage
        tyLabel.fontSize = 50
        tyLabel.fontColor = SKColor.whiteColor()
        tyLabel.position = CGPoint(x: size.width/2, y: size.height/1.25)
        
        let message = "Questions? Feedback?  Reach us at nilnonsensestudios@gmail.com"
        
        let label = SKLabelNode(fontNamed: "GillSans")
        label.text = message
        label.fontSize = 30
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/1.5)
        
        let message1 = "Character Design & Art by Yoshimi Ota"
        
        let label1 = SKLabelNode(fontNamed: "GillSans")
        label1.text = message1
        label1.fontSize = 30
        label1.fontColor = SKColor.whiteColor()
        label1.position = CGPoint(x: size.width/2, y: size.height/2.0)
        
        let message1a = "'Victory Fanfare' by Sakke979 http://sakke979.newgrounds.com/"
        
        let label1a = SKLabelNode(fontNamed: "GillSans")
        label1a.text = message1a
        label1a.fontSize = 30
        label1a.fontColor = SKColor.whiteColor()
        label1a.position = CGPoint(x: size.width/2, y: size.height/2.20)
        
        
        let message2 = "Battleground background art created by Luis Zuno (@ansimuz)"
        
        let label2 = SKLabelNode(fontNamed: "GillSans")
        label2.text = message2
        label2.fontSize = 30
        label2.fontColor = SKColor.whiteColor()
        label2.position = CGPoint(x: size.width/2, y: size.height/2.45)
        
        let message3 = "'Remember' by Tanner Helland http://www.tannerhelland.com/"
        
        let label3 = SKLabelNode(fontNamed: "GillSans")
        label3.text = message3
        label3.fontSize = 30
        label3.fontColor = SKColor.whiteColor()
        label3.position = CGPoint(x: size.width/2, y: size.height/2.75)
        
        let message4 = "'Desert Battle', 'Treacherous Slope', 'Home Castle Theme'"
        let label4 = SKLabelNode(fontNamed: "GillSans")
        label4.text = message4
        label4.fontSize = 30
        label4.fontColor = SKColor.whiteColor()
        label4.position = CGPoint(x: size.width/2, y: size.height/3.08)
        
        let message5 = "by Aaron Krogh https://soundcloud.com/aaron-anderson-11"
        let label5 = SKLabelNode(fontNamed: "GillSans")
        label5.text = message5
        label5.fontSize = 30
        label5.fontColor = SKColor.whiteColor()
        label5.position = CGPoint(x: size.width/2, y: size.height/3.52)

        let message6 = "Spell sound effects created by Mark DiAngelo, Sonidor, Mike Koenig, snottyboi, Conor,"
        let label6 = SKLabelNode(fontNamed: "GillSans")
        label6.text = message6
        label6.fontSize = 30
        label6.fontColor = SKColor.whiteColor()
        label6.position = CGPoint(x: size.width/2, y: size.height/4.1)
        
        let message7 = "BlastwaveFX.com, HopeinAwe, Sound Explorer, Marianne Gagnon, Grenagen"
        let label7 = SKLabelNode(fontNamed: "GillSans")
        label7.text = message7
        label7.fontSize = 30
        label7.fontColor = SKColor.whiteColor()
        label7.position = CGPoint(x: size.width/2, y: size.height/4.9)

        let message8 = "Story written by Christine Liu"
        let label8 = SKLabelNode(fontNamed: "GillSans")
        label8.text = message8
        label8.fontSize = 30
        label8.fontColor = SKColor.whiteColor()
        label8.position = CGPoint(x: size.width/2, y: size.height/6.0)
        
        addChild(tyLabel)
        addChild(label)
        addChild(label1)
        addChild(label1a)
        addChild(label2)
        addChild(label3)
        addChild(label4)
        addChild(label5)
        addChild(label6)
        addChild(label7)
        addChild(label8)
        
        let previousButton = SKSpriteNode(imageNamed: "previousButton")
        previousButton.position = CGPoint(x: 1120, y: 100)
        previousButton.name = "previousButton"
        previousButton.setScale(0.63)
        
        self.addChild(previousButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches as Set<UITouch>
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        if (node.name == "previousButton") {
            let scene = MainMenuScene(size: self.size)
            let transition = SKTransition.crossFadeWithDuration(1)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(scene, transition: transition)
        }
    }
}