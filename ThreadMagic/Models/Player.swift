//
//  Player.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 17/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

class Player: Character {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(imageNamed: String, maxHP: Int, charName: String, attribute: Attribute){
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: SKColor(red: 0, green: 0, blue: 0, alpha: 1) , size: texture.size())
        playableRect = self.frame
        self.maxHP = maxHP
        self.currentHp = maxHP
        self.charName = charName
        self.attribute = attribute
        self.skills["wetTowelSlap"] = WetTowelSlap.self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
