//
//  MainMenu.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/26/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class MainMenuScene: SKScene {
    
    var audioPlayer:AVAudioPlayer!
    
    var mc: Player!
    override func didMoveToView(view: SKView) {
        //self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
        let button1 = SKSpriteNode(imageNamed: "StartNewGame")
        button1.setScale(0.8)
        button1.position = CGPoint(x: 482, y: 220)
        button1.name = "StartNewGame"
        button1.runAction(SKAction.fadeInWithDuration(4))
        button1.alpha = 0
        
        self.addChild(button1)
        
        let button2 = SKSpriteNode(imageNamed: "Continue")
        button2.setScale(0.8)
        button2.position = CGPoint(x: 798, y: 220)
        button2.name = "Continue"
        button2.runAction(SKAction.fadeInWithDuration(5))
        button2.alpha = 0
        
        self.addChild(button2)
        
        let button3 = SKSpriteNode(imageNamed: "Credit")
        button3.setScale(0.8)
        button3.position = CGPoint(x: 635, y: 128)
        button3.name = "Credit"
        button3.runAction(SKAction.fadeInWithDuration(6))
        button3.alpha = 0
        
        self.addChild(button3)
        
        
        let audioFilePath = NSBundle.mainBundle().pathForResource("Good Memories", ofType: "mp3")
        let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioFileUrl, fileTypeHint: nil)
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        }
        catch {
            print("No audio file found!")
        }

        
        
    }
    
    func fadeVolumeAndPause(){
        if self.audioPlayer?.volume > 0.1 {
            self.audioPlayer?.volume = self.audioPlayer!.volume - 0.1
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeVolumeAndPause()
            })
            
        } else {
            self.audioPlayer?.pause()
            self.audioPlayer?.volume = 1.0
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        fadeVolumeAndPause()
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        // If next button is touched, start transition to second scene
        
        let scene = GameScene(size:CGSize(width: 1280, height: 800))
        scene.mc = mc
        if (node.name == "StartNewGame") {
            let transition = SKTransition.crossFadeWithDuration(4)
            self.scene!.view?.presentScene(scene, transition: transition)
        }
    }
}