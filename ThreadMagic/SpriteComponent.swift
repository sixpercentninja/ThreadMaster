//
//  SpriteComponent.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 29/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityNode: SKSpriteNode {
    weak var entity: GKEntity!
}

class SpriteComponent: GKComponent {
    let node: EntityNode
    
    init(entity: GKEntity, texture: SKTexture, size: CGSize){
        node = EntityNode(texture: texture, color: SKColor.whiteColor(), size: size)
        node.entity = entity
    }
}
