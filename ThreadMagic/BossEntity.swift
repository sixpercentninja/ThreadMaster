//
//  BossEntity.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 01/03/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import GameplayKit


class BossEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    
    convenience init(imageNamed: String) {
        self.init()
        
        let texture = SKTexture(imageNamed: imageNamed)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: CGSize(width: 25, height: 30))

        addComponent(spriteComponent)
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 15)
        physicsBody.dynamic = true
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = ColliderType.Boss.rawValue
        spriteComponent.node.physicsBody = physicsBody
    }
}
