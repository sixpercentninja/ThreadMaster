//
//  AramidWard.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 26/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

class AramidWard: Skill {
    override var damage: Int { return 6 }
    override var attackAttribute: Attribute { return Attribute.Resistance }
    override var skillName: String { return "Aramid Ward" }
    override var upgradeValue: Int { return 20 }
    override var skillInformation: String { return "Heals your wounds" }
    override var skillInformation2: String { return "" }
    override var gestureInstruction: SKSpriteNode { return SKSpriteNode(imageNamed: "AramidWardGesture.png")}
    
    required init() {
        super.init()
        self.gestures = [2]
        upgradedSkill = AramidGuard.self
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "aramidWard")
    }
    
    override func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        super.animateAction(scene, caster: caster, target: target) { () -> Void
            in
        }
        let node = animationNode
        node.zPosition = 0.6
        
        node.position = caster.position
        node.setScale(4.2)
        scene.addChild(node)
        let playSFX = SKAction.playSoundFileNamed("chant.wav", waitForCompletion: false)
        node.runAction(playSFX)
        
        let hpToHeal = Int(Double(caster.maxHP) * 0.25)
        
        node.runAction(SKAction.animateWithTextures(animationTextures, timePerFrame: 0.10)) { () -> Void in
            node.removeFromParent()
            self.valuePopUp(scene, caster: target, target: caster, attack: hpToHeal)
            caster.runAction(self.effectActionSequence(), completion: { () -> Void in
                caster.heal(caster, healedHp: hpToHeal)
                completion()
            })
        }
    }
    
    override func effectActionSequence() -> SKAction {
        let colorize = SKAction.colorizeWithColor(.greenColor(), colorBlendFactor: 1, duration: 0.5)
        let rotateLeft = SKAction.rotateToAngle(0.3, duration: 0.1)
        let rotateRight = SKAction.rotateToAngle(-0.3, duration: 0.1)
        let rotateNormal = SKAction.rotateToAngle(0, duration: 0.1)
        return SKAction.sequence([colorize, rotateLeft, rotateRight, rotateLeft, rotateRight, rotateLeft, rotateNormal, colorize.reversedAction()])
    }
}