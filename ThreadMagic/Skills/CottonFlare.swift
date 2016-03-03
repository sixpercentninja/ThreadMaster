//
//  CottonFlare.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 18/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class CottonFlare: Skill {
    override var damage: Int { return 36 }
    override var attackAttribute: Attribute { return Attribute.Heat }
    override var skillName: String { return "Cotton Flare" }
    override var upgradeValue: Int { return 20 }
    override var skillInformation: String { return "Deals light heat damage" }
    override var gestureInstruction: SKSpriteNode { return SKSpriteNode(imageNamed: "CottonFlareGesture.png")}
    
    required init() {
        super.init()
        self.gestures = [7]
        upgradedSkill = CottonBlaze.self
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "cottonFlare.atlas")
    }
    
    override func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        super.animateAction(scene, caster: caster, target: target) { () -> Void
            in
        }
        let node = animationNode
 
        node.zPosition = 1
        
        node.position = target.position
        node.setScale(2.2)
        scene.addChild(node)
        let playSFX = SKAction.playSoundFileNamed("cottonBlaze", waitForCompletion: false)
        node.runAction(playSFX)
        node.runAction(SKAction.animateWithTextures(animationTextures, timePerFrame: 0.05)) { () -> Void in
            node.removeFromParent()
            target.runAction(self.effectActionSequence(), completion: { () -> Void in
                caster.attack(target, skillName: self.skillName)
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