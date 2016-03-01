//
//  GameViewController.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/16/16.
//  Copyright (c) 2016 Andrew Chen. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainMenuScene(size:CGSize(width: 1280, height: 800))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .Fill
        
        let textureAtlas = SKTextureAtlas(named: "mainCharacter")
        
        let mc = Player(imageNamed: textureAtlas.textureNames.first!, maxHP: 50, charName: "Steven", attribute: Attribute.Neutral)

        scene.mc = mc
        skView.presentScene(scene)
    }
    
    //test this
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
}