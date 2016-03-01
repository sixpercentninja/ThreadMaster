//
//  PlayerMoveComponent.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 29/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import GameplayKit
class PlayerMoveComponent: GKComponent {
    //1
    var movement = CGPointZero
    var lastTouchLocation: CGPoint?
    var lastMoveLocation: CGPoint?
    //2
    var lastDirection = LastDirection.Down
    //3
    var spriteComponent: SpriteComponent {
        guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else {
            fatalError("A MovementComponent's entity must have a spriteComponent")
        }
        return spriteComponent
    }
    //4
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity?.componentForClass(AnimationComponent.self) else {
            fatalError("A MovementComponent's entity must have an animationComponent")
        }
        return animationComponent
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        let amountToMove = CGPoint(
            x: movement.x * CGFloat(seconds),
            y: movement.y * CGFloat(seconds))

        if let lastTouchLocation = lastTouchLocation {
            let diff = lastTouchLocation - spriteComponent.node.position
            if (diff.length() <= CGFloat(seconds) * playerSettings.movementSpeed){
                spriteComponent.node.position = lastTouchLocation
                movement = CGPointZero
            }else{
                if let player = entity as? PlayerEntity {
                    player.delegate?.playerMoved()
                }
                spriteComponent.node.position = CGPoint(
                    x: spriteComponent.node.position.x + amountToMove.x,
                    y: spriteComponent.node.position.y + amountToMove.y
                )
            }
        }
        
        if let lastMoveLocation = lastMoveLocation {
            let diff = lastMoveLocation - spriteComponent.node.position
            if (diff.length() < 0.001){
                stopPlayer()
            }
        }
        lastMoveLocation = spriteComponent.node.position
        
        // angle
        switch movement.angle {
        case 0:
            //Left empty on purpose to break switch if there is no angle
            break
        case CGFloat(45).degreesToRadians() ..<
            CGFloat(135).degreesToRadians():
            animationComponent.requestedAnimationState = .Walk_Up
            lastDirection = .Up
            break
        case CGFloat(-135).degreesToRadians() ..<
            CGFloat(-45).degreesToRadians():
            animationComponent.requestedAnimationState = .Walk_Down
            lastDirection = .Down
            break
        case CGFloat(-45).degreesToRadians() ..<
            CGFloat(45).degreesToRadians():
            animationComponent.requestedAnimationState = .Walk_Right
            lastDirection = .Right
            break
        case CGFloat(-180).degreesToRadians() ..<
            CGFloat(-135).degreesToRadians():
            animationComponent.requestedAnimationState = .Walk_Left
            lastDirection = .Left
            break
        case CGFloat(135).degreesToRadians() ..<
            CGFloat(180).degreesToRadians():
            animationComponent.requestedAnimationState = .Walk_Left
            lastDirection = .Left
            break
        default:
            break
        }
        
        if movement.x == 0 && movement.y == 0 {
            switch lastDirection {
            case .Up:
                animationComponent.requestedAnimationState = .Idle_Up
                break
            case .Down:
                animationComponent.requestedAnimationState = .Idle_Down
                break
            case .Right:
                animationComponent.requestedAnimationState = .Idle_Right
                break
            case .Left:
                animationComponent.requestedAnimationState = .Idle_Left
                break
            }
        }
    }
    
    func stopPlayer(){
        movement = CGPointZero
        switch lastDirection {
        case .Up:
            animationComponent.requestedAnimationState = .Idle_Up
            break
        case .Down:
            animationComponent.requestedAnimationState = .Idle_Down
            break
        case .Right:
            animationComponent.requestedAnimationState = .Idle_Right
            break
        case .Left:
            animationComponent.requestedAnimationState = .Idle_Left
            break
        }
        lastTouchLocation = spriteComponent.node.position
    }
}
