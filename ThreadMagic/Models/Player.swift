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
    
    override init(imageNamed: String, maxHP: Int, charName: String, attribute: Attribute){
        super.init(imageNamed: imageNamed, maxHP: maxHP, charName: charName, attribute: attribute)
        self.skills["CWhip"] = CWhip()
        self.skills["CBlaze"] = CBlaze()
        self.skills["WildFire"] = WildFire()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
