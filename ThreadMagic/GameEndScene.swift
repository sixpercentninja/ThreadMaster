//
//  GameEndScene.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 3/3/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameEndScene: SKScene {
    var audioPlayer:SKTAudio!
    
    
    override func didMoveToView(view: SKView) {
        
        SKTAudio.sharedInstance().playBackgroundMusic("Victory Fanfare.mp3")
        backgroundColor = SKColor.blackColor()
        
        let message = "Congrats from us! You have beaten the hardest game ever."
        
        let label = SKLabelNode(fontNamed: "Papyrus")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        restartLevel()
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0), SKAction.runBlock() {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = MainMenuScene(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
            }
            ])
        )
    }
    
    func restartLevel(){
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
    }
}
