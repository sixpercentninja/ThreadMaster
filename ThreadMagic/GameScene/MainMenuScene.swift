//
//  MainMenu.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/26/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class MainMenuScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
    self.addBG("Title.png")
    self.size = CGSize(width: 1280, height: 800)

        
        let button1 = SKSpriteNode(imageNamed: "startButton")
        button1.setScale(0.7)
        button1.position = CGPoint(x: 1120, y: 275)
        button1.name = "StartNewGame"
        button1.runAction(SKAction.fadeInWithDuration(3))
        button1.alpha = 0
        
        let button2 = SKSpriteNode(imageNamed: "continueButton")
        button2.setScale(0.7)
        button2.position = CGPoint(x: 1120, y: 195)
        button2.name = "Continue"
        button2.runAction(SKAction.fadeInWithDuration(3))
        button2.alpha = 0
        
        let button3 = SKSpriteNode(imageNamed: "creditsButton")
        button3.setScale(0.7)
        button3.position = CGPoint(x: 1120, y: 115)
        button3.name = "Credit"
        button3.runAction(SKAction.fadeInWithDuration(3))
        button3.alpha = 0
        
        let titleImage = SKSpriteNode(imageNamed: "TitleName")
//        titleImage.position = CGPoint(x: 270, y: 655)
        titleImage.position = CGPoint(x: 1023, y: 416)
        titleImage.setScale(1.1)
        titleImage.runAction(SKAction.fadeInWithDuration(3))
        titleImage.alpha = 0
        
        self.addChild(button1)
        self.addChild(button2)
        self.addChild(button3)
        self.addChild(titleImage)
        
        SKTAudio.sharedInstance().playBackgroundMusic("Treacherous Slopes.mp3")
        
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
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let moc = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "SavePlayer")
            do{
                let array = try moc.executeFetchRequest(fetchRequest) as! [SavePlayer]
                for player in array{
                    moc.deleteObject(player)
                }
            } catch{
                fatalError()
            }
            
            let skillFetchRequest = NSFetchRequest(entityName: "PlayerSkill")
            do{
                let array = try moc.executeFetchRequest(skillFetchRequest) as! [PlayerSkill]
                for skill in array{
                    moc.deleteObject(skill)
                }
            } catch{
                fatalError()
            }
            
            let player = NSEntityDescription.insertNewObjectForEntityForName("SavePlayer", inManagedObjectContext: moc) as! SavePlayer
            
            player.totalExperience = 100
            player.maxHP = 50
            do {
                try moc.save()
            }catch{
                fatalError("failure to save context: \(error)")
            }
            

            
            
            let transition = SKTransition.crossFadeWithDuration(1)
            let scene = StoryScene(size:CGSize(width: 1280, height: 800))
            self.scene!.view?.presentScene(scene, transition: transition)
            
        }else if name == "Continue"{
            let transition = SKTransition.crossFadeWithDuration(1)
            
            let savePlayer = SavePlayer.currentPlayer
            let mapLevel = MapLevel(rawValue: Int(savePlayer.mapLevel!))!
            
            let scene = WorldMapScene(size:CGSize(width: 1280, height: 800), mapLevel: mapLevel)
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