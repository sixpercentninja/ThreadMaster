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

        backgroundColor = SKColor.whiteColor()
        
//        let message = won ? "\(mc.charName) won!" : "You didn't make it, soorry!"
        
        if won == true {
                SKTAudio.sharedInstance().playBackgroundMusic("Victory Fanfare.mp3")
                let bg = SKSpriteNode(imageNamed: "Victory.png")
                bg.name = "bg"
                bg.zPosition = -1
                bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                bg.position = CGPoint(x: size.width/2, y: size.height/2)
                addChild(bg)
            
            
            let duration = SKAction.waitForDuration(2.0)
            
            self.runAction(duration, completion: { () -> Void in
                let button = UIButton(type: UIButtonType.System) as UIButton
                button.frame = CGRectMake(bg.position.x/2 - 130, bg.position.y/2, 275, 25)
                button.backgroundColor = UIColor.clearColor()
                button.setTitle("Continue", forState: UIControlState.Normal)
                button.setTitleColor(UIColor.purpleColor(), forState: UIControlState.Normal)
                button.titleLabel?.font = UIFont(name: "Papyrus", size: 25)
                button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view?.addSubview(button)
            })
        
        } else {
            
            backgroundColor = SKColor.blackColor()

            let message = "Game Over..."
            
            let label = SKLabelNode(fontNamed: "Papyrus")
            label.text = message
            label.fontSize = 40
            label.fontColor = SKColor.redColor()
            label.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(label)
            
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(4.0), SKAction.runBlock() {
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let scene = self.worldMapScene
                    self.view?.presentScene(scene, transition: reveal)
                    
                }
                ]))
        }
      
    
    }
    
    func buttonAction(sender:UIButton!) {
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let scene = self.worldMapScene
        self.view?.presentScene(scene, transition: reveal)
        sender.removeFromSuperview()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}