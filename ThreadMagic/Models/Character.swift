//
//  Character.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 17/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

enum Attribute: Int, CustomStringConvertible {
    case Strength = 0, Pattern, Heat, Resistance, Neutral
    
    var attributeName: String {
        switch self {
        case .Strength:
            return "Strength"
        case .Pattern:
            return "Pattern"
        case .Heat:
            return "Heat"
        case .Resistance:
            return "Resistance"
        case .Neutral:
            return "Neutral"
        }
    }
    
    var description: String {
        return self.attributeName
    }
}

class Character: SKSpriteNode {
    var maxHP: Int = 0
    var currentHp: Int = 0
    var charName: String = ""
    var skills: [String: Skill] = [:]
    var attribute: Attribute = Attribute.Neutral
    var playableRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    let label = SKLabelNode()
    
    var textureAtlas: SKTextureAtlas?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(imageNamed: String, maxHP: Int, charName: String, attribute: Attribute){
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: SKColor(red: 0, green: 0, blue: 0, alpha: 1) , size: texture.size())
        playableRect = self.frame
        self.maxHP = maxHP
        self.currentHp = maxHP
        self.charName = charName
        self.attribute = attribute
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLabel(){
        label.text = "HP \(currentHp)/\(maxHP)"
        label.fontColor = SKColor.redColor()
        label.fontSize = 50.0
        label.fontName = "AvenirNext-Bold"
        print(self.size)
        label.position = CGPoint(x: 0, y: self.size.height/2 + 10)
        addChild(label)
    }
    
    func updateLabel() {
        label.text = "HP \(currentHp)/\(maxHP)"
    }
    
    func attack(enemy: Character, skillName: String) {
        if let skill = skills[skillName]{
            let damage = skill.calculate(enemy.attribute)
            enemy.currentHp -= damage
            enemy.currentHp = max(0, enemy.currentHp )
        }
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func nameAndHP() -> String{
        return "\(charName): \(currentHp)/\(maxHP)"
    }
}


