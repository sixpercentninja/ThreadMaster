//
//  Skill.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 18/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation

class Skill {
    class var damage: Int { return 0 }
    class var attackAttribute: Attribute { return Attribute.Heat }
    
    class func calculate(enemyAttribute: Attribute) -> Int {
        return calculateDamageWithAttributes(damage, attackAttribute: attackAttribute, enemyAttribute: enemyAttribute)
    }
    
    class func calculateDamageWithAttributes(damage: Int, attackAttribute: Attribute, enemyAttribute: Attribute) -> Int {
        let superEffectiveMultipler = 1.1
        let notEffectiveMultiplier = 0.9
        
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