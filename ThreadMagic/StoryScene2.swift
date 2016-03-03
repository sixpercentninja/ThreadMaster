//
//  StoryScene2.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 3/2/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import UIKit
import SpriteKit

class StoryScene2: SKScene {
    
    var story = SKNode()
    var story2 = SKNode()
    var mc: Player!
    let bgImage = SKSpriteNode(imageNamed: "Parchment")
    var button1 = SKSpriteNode()
    var bg = SKSpriteNode()
    override func didMoveToView(view: SKView) {
        
        //SKTAudio.sharedInstance().playBackgroundMusic("RememberLoudest.mp3")
        
        
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        bgImage.runAction(SKAction.fadeInWithDuration(1))
        
        self.addChild(bgImage)
        
        
        story = createMultiLineText("No one...that is, until our foolish hero came along.  \nSold as a child into apprenticeship at the local tailor’s shop, \nKumo dreamed of a grander life - of becoming a fearsome \nwarrior that could command the respect of all around him, \ninstead of sitting every day at the shop weaving and sewing \nfinery for richer folk than he.", color: UIColor.init(red: (170/255), green: (0/255), blue: (2/255), alpha: 1), fontSize: 40, fontName: "Papyrus", fontPosition: CGPoint(x: size.width/2, y: size.height/1.35), fontLineSpace: 20.0)
        
        story.zPosition = 1
        
        //story.runAction(SKAction.fadeInWithDuration(5))
        
        story2 = createMultiLineText("With nothing but his magic threads and the clothes on his \nback, he set out on his journey to defeat the ultimate \nWeavers of fate.", color: UIColor.init(red: (170/255), green: (0/255), blue: (2/255), alpha: 1), fontSize: 40, fontName: "Papyrus", fontPosition: CGPoint(x: size.width/2, y: size.height/2.5), fontLineSpace: 20.0)
        
        story2.zPosition = 1
        
        //story2.runAction(SKAction.fadeInWithDuration(5))
        
        addChild(story)
        addChild(story2)
        
        button1 = SKSpriteNode(imageNamed: "continueButton")
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
        if let name = node.name {
        if (name == "Continue") {
            bgImage.removeFromParent()
            story.removeFromParent()
            story2.removeFromParent()

            addBG("tutorial1.png")
            
            button1 = SKSpriteNode(imageNamed: "continueButton")
            button1.setScale(0.8)
            button1.position = CGPoint(x: 400, y: -223)
            button1.name = "Continue1"
            button1.zPosition = 1
            bg.addChild(button1)
            
        }else if (name == "Continue1") {
            bg.removeFromParent()
            story.removeFromParent()
            story2.removeFromParent()
            
            addBG("tutorial2.png")
            
            button1 = SKSpriteNode(imageNamed: "continueButton")
            button1.setScale(0.8)
            button1.position = CGPoint(x: 400, y: -223)
            button1.name = "Continue2"
            button1.zPosition = 1
            bg.addChild(button1)
            
        }else if (name == "Continue2") {
            bg.removeFromParent()
            story.removeFromParent()
            story2.removeFromParent()
            
            addBG("tutorial3.png")
            
            button1 = SKSpriteNode(imageNamed: "continueButton")
            button1.setScale(0.8)
            button1.position = CGPoint(x: 400, y: -223)
            button1.name = "Continue3"
            button1.zPosition = 1
            bg.addChild(button1)
        } else if (name == "Continue3") {
            bg.removeFromParent()
            story.removeFromParent()
            story2.removeFromParent()
            
            addBG("tutorial4.png")
            
            button1 = SKSpriteNode(imageNamed: "continueButton")
            button1.setScale(0.8)
            button1.position = CGPoint(x: 400, y: -223)
            button1.name = "Continue4"
            button1.zPosition = 1
            bg.addChild(button1)
            
        }else if (name == "Continue4") {
            bg.removeFromParent()
            story.removeFromParent()
            story2.removeFromParent()
            
            addBG("tutorial5.png")
            
            button1 = SKSpriteNode(imageNamed: "continueButton")
            button1.setScale(0.8)
            button1.position = CGPoint(x: 400, y: -223)
            button1.name = "Continue5"
            button1.zPosition = 1
            bg.addChild(button1)
        }else if (name == "Continue5") {
            bg.removeFromParent()
            story.removeFromParent()
            story2.removeFromParent()
            
            addBG("tutorial6.png")
            
            button1 = SKSpriteNode(imageNamed: "continueButton")
            button1.setScale(0.8)
            button1.position = CGPoint(x: 400, y: -223)
            button1.name = "Continue6"
            button1.zPosition = 1
            bg.addChild(button1)
        }
        
        else if (name == "Continue6") {
            let transition = SKTransition.crossFadeWithDuration(2)
            self.scene!.view?.presentScene(scene, transition: transition)
        }
        }
    }
    
    func addBG(backgroundName: String) {
        bg = SKSpriteNode(imageNamed: backgroundName)
        bg.zPosition = -1
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(bg)
    }
    
}