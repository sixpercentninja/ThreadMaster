//
//  CottonBlaze.swift
//  ThreadMagic
//
//  Created by Steven Yang on 2/22/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class CottonBlaze: Skill {
    override var damage: Int { return 20 }
    override var attackAttribute: Attribute { return Attribute.Heat }
    override var skillName: String { return "CottonBlaze" }
    
    override init() {
        super.init()
        self.gestures = [7, 1]
        self.thread = .Cotton
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "cottonBlaze.atlas")
    }
    
    override func animateAction(scene: SKScene, target: SKSpriteNode, completion: () -> Void ) -> Void {
        let node = animationNode
        node.zPosition = 0.6
        
        node.position = target.position
        node.setScale(5.0)
        scene.addChild(node)
        node.runAction(SKAction.sequence([SKAction.playSoundFileNamed("cottonBlaze.wav", waitForCompletion: false),SKAction.animateWithTextures(animationTextures, timePerFrame: 0.08)])) { () -> Void in
            node.removeFromParent()
            target.runAction(self.effectActionSequence(), completion: { () -> Void in
                completion()
            })
        }
    }
    
    override func effectActionSequence() -> SKAction {
        let colorize = SKAction.colorizeWithColor(.redColor(), colorBlendFactor: 1, duration: 0.5)
        let rotateLeft = SKAction.rotateToAngle(0.3, duration: 0.1)
        let rotateRight = SKAction.rotateToAngle(-0.3, duration: 0.1)
        let rotateNormal = SKAction.rotateToAngle(0, duration: 0.1)
        return SKAction.sequence([colorize, rotateLeft, rotateRight, rotateLeft, rotateRight, rotateLeft, rotateNormal, colorize.reversedAction()])
    }
    

}