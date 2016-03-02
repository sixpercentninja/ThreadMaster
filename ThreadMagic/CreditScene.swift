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
        
        let message = "Special Thanks To:"
        
        let label = SKLabelNode(fontNamed: "")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
    }
}