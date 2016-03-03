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
    case Cotton = 0, Silk, Aramid, Rayon, Physical
    
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
        case .Physical:
            return "Physical"
        }
    }
    
    var description: String {
        return self.threadName
    }
    
    
}

class Skill{
    var damage: Int { return 0 }
    var attackAttribute: Attribute { return Attribute.Heat }
    var skillName: String { return "Not Implemented" }
    var gestures: [Int]!
    var gestureInstruction: SKSpriteNode { return SKSpriteNode(imageNamed: "Not Implemented")}
    var skillInformation: String {return "Not Implemented" }
    var skillInformation2: String {return "" }
    var thread: Thread!
    var useCount = 0
    var upgradeValue: Int { return 20 }
    var upgradedSkill: Skill.Type?
    
    required init() {
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
        useCount++
    }
    
    func effectActionSequence() -> SKAction{
        return SKAction()
    }
    
    func valuePopUp(scene: SKScene, caster: Character, target: Character, attack: Int) {
        let bounceHigh = SKAction.moveTo(CGPoint(x: target.position.x, y: target.position.y + 30), duration: 0.3)
        let bounceDown = SKAction.moveTo(CGPoint(x: target.position.x, y: target.position.y - 30), duration: 0.6)
        let bounceHighLite = SKAction.moveTo(CGPoint(x: target.position.x, y: target.position.y - 10), duration: 0.2)
        let bounceDownLite = SKAction.moveTo(CGPoint(x: target.position.x, y: target.position.y - 40), duration: 0.3)
        let waitDuration = SKAction.waitForDuration(1.0)
        let sequence = SKAction.sequence([bounceHigh, bounceDown, bounceHighLite, bounceDownLite, waitDuration])
        
        
        let getDamaged = SKLabelNode()
        
        
        getDamaged.text = "\(attack)"
        getDamaged.zPosition = 1.1
        getDamaged.position = CGPoint(x: target.position.x, y: target.position.y)
        
        getDamaged.fontColor = SKColor.redColor()
        getDamaged.fontSize = 45.0
        getDamaged.fontName = "Optima-ExtraBlack"

        scene.addChild(getDamaged)
        
        getDamaged.runAction(sequence) { () -> Void in
            getDamaged.removeFromParent()
        }
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