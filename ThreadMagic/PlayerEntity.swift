//
//  PlayerEntity.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 29/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol PlayerEntityDelegate: class {
    func playerMoved()
}

class PlayerEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var moveComponent: PlayerMoveComponent!
    
    weak var delegate: PlayerEntityDelegate?
    
    override init() {
        super.init()
        
        let texture = SKTexture(imageNamed: "PlayerIdle_12_00.png")
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: CGSize(width: 25, height: 30))
        animationComponent = AnimationComponent(node: spriteComponent.node,
            textureSize: CGSizeMake(25,30), animations: loadAnimations())
        moveComponent = PlayerMoveComponent()
        
        addComponent(moveComponent)
        addComponent(animationComponent)
        addComponent(spriteComponent)
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 15)
        physicsBody.dynamic = true
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = ColliderType.Player.rawValue
        physicsBody.collisionBitMask = ColliderType.Obstacle.rawValue | ColliderType.Boss.rawValue
        physicsBody.contactTestBitMask = ColliderType.Boss.rawValue
        spriteComponent.node.physicsBody = physicsBody
    }
    
    func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: "player")
        var animations = [AnimationState: Animation]()
        animations[.Walk_Down] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Walk_Down.rawValue,
            forAnimationState: .Walk_Down)
        animations[.Walk_Up] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Walk_Up.rawValue,
            forAnimationState: .Walk_Up)
        animations[.Walk_Left] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Walk_Left.rawValue,
            forAnimationState: .Walk_Left)
        animations[.Walk_Right] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Walk_Right.rawValue,
            forAnimationState: .Walk_Right)
        animations[.Idle_Down] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Idle_Down.rawValue,
            forAnimationState: .Idle_Down)
        animations[.Idle_Up] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Idle_Up.rawValue,
            forAnimationState: .Idle_Up)
        animations[.Idle_Left] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Idle_Left.rawValue,
            forAnimationState: .Idle_Left)
        animations[.Idle_Right] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: AnimationState.Idle_Right.rawValue,
            forAnimationState: .Idle_Right)
            return animations
    }
}
