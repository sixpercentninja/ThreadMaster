//
//  SpiderWeb.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 21/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class SpiderWeb: Skill {
    override var damage: Int { return 5 }
    override var attackAttribute: Attribute { return Attribute.Pattern }
    override var upgradeValue: Int { return 20 }
    
    override var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "spider_web")
    }
    
    override func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        super.animateAction(scene, caster: caster, target: target) { () -> Void
            in
        }
        let node = animationNode
        node.position = target.position
        scene.addChild(node)
        node.runAction(SKAction.scaleTo(0, duration: 1.5))

        let scaleSmall = SKAction.scaleBy(0.1, duration: 1.5)
        target.runAction(SKAction.sequence([scaleSmall, scaleSmall.reversedAction()]), completion: { () -> Void in
            node.removeFromParent()
            caster.attack(target, skillName: self.skillName)
            completion()
        })

    }

}