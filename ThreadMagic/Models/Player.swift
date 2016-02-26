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
        self.skills["CottonFlare"] = CottonFlare()
        self.skills["CottonBlaze"] = CottonBlaze()
        self.skills["WildFire"] = WildFire()
        self.skills["SilkTrick"] = SilkTrick()
        self.skills["SilkDaze"] = SilkDaze()
        self.skills["WildFire"] = WildFire()
        self.skills["PieceDeResistance"] = PieceDeResistance()
        self.skills["AramidWard"] = AramidWard()
        self.skills["AramidGuard"] = AramidGuard()
        self.skills["AegisLastStand"] = AegisLastStand()
        self.skills["RayonStrike"] = RayonStrike()
        self.skills["RayonBash"] = RayonBash()
        self.skills["KusanagiNoTsurugi"] = KusanagiNoTsurugi()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
