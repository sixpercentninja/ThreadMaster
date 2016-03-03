//
//  Constrict.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 26/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

class Constrict: Skill {
    override var damage: Int { return 24 }
    override var attackAttribute: Attribute { return Attribute.Neutral }
    override var skillName: String { return "Constrict" }
    override var skillInformation: String { return "Deals moderate neutral" }
    override var skillInformation2: String { return "damage" }
    override var gestureInstruction: SKSpriteNode { return SKSpriteNode(imageNamed: "ConstrictGesture.png")}
    override var upgradeValue: Int { return 5 }
    
    required init() {
        super.init()
        self.gestures = [1, 3]
        self.thread = .Physical
        upgradedSkill = Thrash.self
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "constrict")
    }
    
    override func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        super.animateAction(scene, caster: caster, target: target) { () -> Void
            in
        }
        let node = animationNode
        node.zPosition = 0.6
        
        node.position = target.position
        node.setScale(5.0)
        scene.addChild(node)
        
        node.runAction(SKAction.sequence([SKAction.playSoundFileNamed("chainDrop.wav", waitForCompletion: false),SKAction.animateWithTextures(animationTextures, timePerFrame: 0.08)])) { () -> Void in
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