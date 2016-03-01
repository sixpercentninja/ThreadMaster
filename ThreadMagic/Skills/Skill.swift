//
//  Skill.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 18/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

enum Thread: Int, CustomStringConvertible {
    case Cotton = 0, Silk, Aramid, Rayon
    
    var threadName: String {
        switch self {
        case .Cotton:
            return "Cotton"
        case .Silk:
            return "Silk"
        case .Aramid:
            return "Aramid"
        case .Rayon:
            return "Rayon"
        }
    }
    
    var description: String {
        return self.threadName
    }
    
    
}

class Skill {
    var damage: Int { return 0 }
    var attackAttribute: Attribute { return Attribute.Heat }
    var skillName: String { return "Not Implemented" }
    var gestures: [Int]!
    var thread: Thread!
    var upgradedSkill: Skill?
    
    init() {
    }
    
    var textureAtlas: SKTextureAtlas {
        return SKTextureAtlas()
    }
    
    var animationNode: SKSpriteNode {
        return SKSpriteNode(texture: animationTextures[0])
    }

    var animationTextures: [SKTexture] {
        return textureAtlas.textureNames.sort().map({ textureAtlas.textureNamed($0) })
    }
    
    func animateAction(scene: SKScene, caster: Character, target: Character, completion: () -> Void ) -> Void {
        
    }
    
    func effectActionSequence() -> SKAction{
        return SKAction()
    }
    
    func calculate(enemyAttribute: Attribute) -> Int {
        return calculateDamageWithAttributes(damage, attackAttribute: attackAttribute, enemyAttribute: enemyAttribute)
    }
    
    func calculateDamageWithAttributes(damage: Int, attackAttribute: Attribute, enemyAttribute: Attribute) -> Int {
        let superEffectiveMultipler = 1.5
        let notEffectiveMultiplier = 0.5
        
        switch attackAttribute {
        case .Strength:
            if(enemyAttribute == .Pattern){
                return Int(Double(damage) * notEffectiveMultiplier)
            }
            if(enemyAttribute == .Resistance){
                return Int(Double(damage) * superEffectiveMultipler)
            }
        case .Pattern:
            if(enemyAttribute == .Heat){
                return Int(Double(damage) * notEffectiveMultiplier)
            }
            if(enemyAttribute == .Strength){
                return Int(Double(damage) * superEffectiveMultipler)
            }
        case .Heat:
            if(enemyAttribute == .Resistance){
                return Int(Double(damage) * notEffectiveMultiplier)
            }
            if(enemyAttribute == .Pattern){
                return Int(Double(damage) * superEffectiveMultipler)
            }
        case .Resistance:
            if(enemyAttribute == .Strength){
                return Int(Double(damage) * notEffectiveMultiplier)
            }
            if(enemyAttribute == .Heat){
                return Int(Double(damage) * superEffectiveMultipler)
            }
        default:
            break
        }
        return damage
    }
}