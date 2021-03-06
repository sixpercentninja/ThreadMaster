//
//  AnimationComponent.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 29/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Animation {
    let animationState: AnimationState
    let textures: [SKTexture]
    let repeatTexturesForever: Bool
}
class AnimationComponent: GKComponent {
    static let actionKey = "Action"
    static let timePerFrame = NSTimeInterval(1.0 / 20.0)
    var something = NSTimeInterval(1.0 / 20.0)
    let node: SKSpriteNode
    
    var animations: [AnimationState: Animation]
    
    private(set) var currentAnimation: Animation?
    
    var requestedAnimationState: AnimationState?
    
    init(node: SKSpriteNode, textureSize: CGSize, animations: [AnimationState: Animation]){
        self.node = node
        self.animations = animations
    }
    
    private func runAnimationForAnimationState(animationState: AnimationState) {
        if currentAnimation != nil && currentAnimation!.animationState == animationState { return }
        
        guard let animation = animations[animationState] else {
            print("Unknown animation for state \(animationState.rawValue)")
            return
        }
        
        node.removeActionForKey(AnimationComponent.actionKey)
        
        let texturesAction: SKAction
        
        if animation.repeatTexturesForever {
                texturesAction = SKAction.repeatActionForever(
            SKAction.animateWithTextures(animation.textures,
            timePerFrame: something))
            } else {
                texturesAction = SKAction.animateWithTextures(animation.textures,
            timePerFrame: something)
        }
        
        node.runAction(texturesAction, withKey: AnimationComponent.actionKey)
        
        currentAnimation = animation
    }
  
    override func updateWithDeltaTime(deltaTime: NSTimeInterval) {
        super.updateWithDeltaTime(deltaTime)
        
        if let animationState = requestedAnimationState {
        runAnimationForAnimationState(animationState)
        requestedAnimationState = nil
        }
    }
    
    class func animationFromAtlas(atlas: SKTextureAtlas, withImageIdentifier identifier: String, forAnimationState animationState: AnimationState, repeatTexturesForever: Bool = true) -> Animation {
        let textures = atlas.textureNames.filter {
            $0.containsString("\(identifier)_")
        }.sort {
            $0 < $1
        }.map {
            atlas.textureNamed($0)
        }
            
        return Animation(animationState: animationState, textures: textures, repeatTexturesForever: repeatTexturesForever)
    }
}