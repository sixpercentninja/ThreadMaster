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
    
    var story = SKNode()
    
    var mc: Player!
    
    override func didMoveToView(view: SKView) {
        
        SKTAudio.sharedInstance().playBackgroundMusic("RememberLoudest.mp3")
        
        let bgImage = SKSpriteNode(imageNamed: "Parchment")
        
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        bgImage.runAction(SKAction.fadeInWithDuration(1))
        
        self.addChild(bgImage)
        

        let story = createMultiLineText("Since ancient times long past, it has been said that \nthose Moirai ruled the fates of both men and gods alike.  \nNone may challenge their decrees, woven into that \ntapestry known as life.  Aisa, that most fearsome of \nthe goddesses, cut down all with her deathly shears \nwhen she sees fit.  No one could fight against their fate, \nand no one dared to challenge the destiny that the \nMoirai wove for them.", color: UIColor.init(red: (170/255), green: (0/255), blue: (2/255), alpha: 1), fontSize: 40, fontName: "Papyrus", fontPosition: CGPoint(x: size.width/2, y: size.height/1.38), fontLineSpace: 20.0)
        
        story.zPosition = 1
        story.runAction(SKAction.fadeInWithDuration(5))
        
        addChild(story)
        
        let button1 = SKSpriteNode(imageNamed: "continueButton")
        button1.setScale(0.8)
        button1.position = CGPoint(x: 400, y: -223)
        button1.name = "Continue"
        button1.alpha = 0
        button1.runAction(SKAction.fadeInWithDuration(5))
        button1.zPosition = 1
        
        bgImage.addChild(button1)
        
        
    }
    
    func createMultiLineText(textToPrint:String, color:UIColor, fontSize:CGFloat, fontName:String, fontPosition:CGPoint, fontLineSpace:CGFloat)->SKNode{
        
        let textBlock = SKNode()
        
        let textArr = textToPrint.componentsSeparatedByString("\n")
        
        var lineNode: SKLabelNode
        for line: String in textArr {
            lineNode = SKLabelNode(fontNamed: fontName)
            lineNode.text = line
            lineNode.fontSize = fontSize
            lineNode.fontColor = color
            lineNode.fontName = fontName
            lineNode.position = CGPointMake(fontPosition.x,fontPosition.y - CGFloat(textBlock.children.count ) * fontSize + fontLineSpace)
            textBlock.addChild(lineNode)
        }
        
        return textBlock
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        SKTAudio.sharedInstance().fadeVolumeAndPause()
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        let savePlayer = SavePlayer.currentPlayer
        let mapLevel = MapLevel(rawValue: Int(savePlayer.mapLevel!))!
        let scene = WorldMapScene(size:CGSize(width: 1280, height: 800), mapLevel: mapLevel)
        if (node.name == "Continue") {
            let transition = SKTransition.crossFadeWithDuration(2)
            self.scene!.view?.presentScene(scene, transition: transition)
        }
    }

}
