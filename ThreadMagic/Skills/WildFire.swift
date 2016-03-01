//
//  WildFire.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 24/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class WildFire: Skill {
    override var damage: Int { return 88 }
    override var attackAttribute: Attribute { return Attribute.Heat }
    override var skillName: String { return "Wildfire" }
    
    override init() {
        super.init()
        self.gestures = [7, 1, 4]
        self.thread = .Cotton
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "wildFire")
    }
    
    override func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        let node = animationNode
        node.zPosition = 0.6
        
        node.position = target.position
        node.setScale(3.0)
        scene.addChild(node)
        
        node.runAction(SKAction.animateWithTextures(animationTextures, timePerFrame: 0.15)) { () -> Void in
            node.removeFromParent()
            target.runAction(self.effectActionSequence(), completion: { () -> Void in
                caster.attack(target, skillName: self.skillName)
                completion()
            })
        }
    }
    
    override func effectActionSequence() -> SKAction {
        let colorize = SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1, duration: 0.5)
        let jumpUp = SKAction.moveByX(0, y: 100, duration: 0.2)
        return SKAction.sequence([colorize, jumpUp, jumpUp.reversedAction(), jumpUp, jumpUp.reversedAction(), colorize.reversedAction()])
    }
    
}