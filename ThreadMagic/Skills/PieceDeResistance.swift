//
//  PieceDeResistance.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 26/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

class PieceDeResistance: Skill {
    override var damage: Int { return 140 }
    override var attackAttribute: Attribute { return Attribute.Pattern }
    override var skillName: String { return "Pièce de Résistance" }
    override var skillInformation: String { return "Deals heavy pattern damage" }
    
    override var gestureInstruction: SKSpriteNode { return SKSpriteNode(imageNamed: "PieceDeResistanceGesture.png")}
    
    required init() {
        super.init()
        self.gestures = [0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7]
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "pieceDeResistance")
    }
    
    override func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        super.animateAction(scene, caster: caster, target: target) { () -> Void
            in
        }
        let node = animationNode
        node.zPosition = 0.6
        
        node.position = target.position
        node.setScale(4.2)
        scene.addChild(node)
        let playSFX = SKAction.playSoundFileNamed("darkLaugh.wav", waitForCompletion: false)
        node.runAction(playSFX)
        
        node.runAction(SKAction.animateWithTextures(animationTextures, timePerFrame: 0.10)) { () -> Void in
            node.removeFromParent()
            self.valuePopUp(scene, caster: caster, target: target, attack: caster.skillDamage(target, skillName: self.skillName))
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
