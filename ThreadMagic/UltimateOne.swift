//
//  UltimateOne
//  ThreadMagic
//
//  Created by Wong You Jing on 2/22/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

class UltimateOne: Skill {
    override var damage: Int { return 200 }
    override var attackAttribute: Attribute { return Attribute.Neutral }
    override var skillName: String { return "Ultimate One" }
    
    
    required init() {
        super.init()
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "ultimateOne")
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
        node.runAction(SKAction.sequence([SKAction.playSoundFileNamed("mortarSound.wav", waitForCompletion: false),SKAction.animateWithTextures(animationTextures, timePerFrame: 0.08)])) { () -> Void in
            node.removeFromParent()
            self.valuePopUp(scene, caster: caster, target: target, attack: caster.skillDamage(target, skillName: self.skillName))
            target.runAction(self.effectActionSequence(), completion: { () -> Void in
                caster.attack(target, skillName: self.skillName)
                completion()
            })
        }
    }
    
    override func effectActionSequence() -> SKAction {
        let colorize = SKAction.colorizeWithColor(.yellowColor(), colorBlendFactor: 1, duration: 0.5)
        let rotateLeft = SKAction.rotateToAngle(0.3, duration: 0.1)
        let rotateRight = SKAction.rotateToAngle(-0.3, duration: 0.1)
        let rotateNormal = SKAction.rotateToAngle(0, duration: 0.1)
        return SKAction.sequence([colorize, rotateLeft, rotateRight, rotateLeft, rotateRight, rotateLeft, rotateNormal, colorize.reversedAction()])
    }
    
    
}