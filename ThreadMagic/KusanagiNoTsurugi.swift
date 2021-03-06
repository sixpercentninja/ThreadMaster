//
//  KusanagiNoTsurugi.swift
//  ThreadMagic
//
//  Created by Steven Yang on 2/22/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class KusanagiNoTsurugi: Skill {
    override var damage: Int { return 210 }
    override var attackAttribute: Attribute { return Attribute.Strength }
    override var skillName: String { return "Kusanagi No Tsurugi" }
    override var skillInformation: String { return "Deals heavy strength damage" }
    
    override var gestureInstruction: SKSpriteNode { return SKSpriteNode(imageNamed: "KusanagiNoTsurugiGesture.png")}
    
    
    required init() {
        super.init()
        self.gestures = [1, 6, 3]
    }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "kusanagiNoTsurugi.atlas")
    }
    
    override func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        super.animateAction(scene, caster: caster, target: target) { () -> Void
            in
        }
        let node = animationNode
        node.zPosition = 0.6
        
        node.position = CGPoint(x: target.position.x + 40, y: target.position.y)
        node.setScale(5.0)
        
        scene.enumerateChildNodesWithName("bg") { (background, _) -> Void in
            
            background.runAction(SKAction.colorizeWithColor(.blackColor(), colorBlendFactor: 1.0, duration: 3.0), completion: { () -> Void in
                scene.addChild(node)
                let playSFX = SKAction.playSoundFileNamed("cottonBlaze", waitForCompletion: false)
                node.runAction(playSFX)
                node.runAction(SKAction.sequence([SKAction.playSoundFileNamed("sonicBoom.wav", waitForCompletion: false),SKAction.animateWithTextures(self.animationTextures, timePerFrame: 0.08)])) { () -> Void in
                    
                    node.removeFromParent()
                    self.valuePopUp(scene, caster: caster, target: target, attack: caster.skillDamage(target, skillName: self.skillName))
                    
                    target.runAction(self.effectActionSequence(), completion: { () -> Void in
                        background.runAction(SKAction.colorizeWithColor(.whiteColor(), colorBlendFactor: 0.0, duration: 3.0))
                        caster.attack(target, skillName: self.skillName)
                        completion()
                    })
                }
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