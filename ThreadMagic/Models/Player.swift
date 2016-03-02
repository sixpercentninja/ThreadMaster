//
//  Player.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 17/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

class Player: Character {
    static let mainPlayer = Player(imageNamed: SKTextureAtlas(named: "mainCharacter").textureNames.first!, maxHP: 50, charName: "Steven", attribute: Attribute.Neutral)
    
    var level: Int = 1
    var totalExperience: Int = 100 {
        didSet {
            calculateLevel()
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        totalExperience = 0
        super.init(texture: texture, color: color, size: size)
    }
    
    override init(imageNamed: String, maxHP: Int, charName: String, attribute: Attribute){
        totalExperience = 0
        super.init(imageNamed: imageNamed, maxHP: maxHP, charName: charName, attribute: attribute)
        self.skills["Whip"] = Whip()
        self.skills["Constrict"] = Constrict()
        self.skills["Thrash"] = Thrash()
        self.skills["Cotton Flare"] = CottonFlare()
        self.skills["Cotton Blaze"] = CottonBlaze()
        self.skills["Wildfire"] = WildFire()
        self.skills["Silk Trick"] = SilkTrick()
        self.skills["Silk Daze"] = SilkDaze()
        self.skills["Pièce de Résistance"] = PieceDeResistance()
        self.skills["Aramid Ward"] = AramidWard()
        self.skills["Aramid Guard"] = AramidGuard()
        self.skills["Aegis' Last Stand"] = AegisLastStand()
        self.skills["Rayon Strike"] = RayonStrike()
        self.skills["Rayon Bash"] = RayonBash()
        self.skills["Kusanagi No Tsurugi"] = KusanagiNoTsurugi()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateLevel(){
        let oldLevel = level
        let multiplier = Double(totalExperience)/100.0
        let newLevel = logWithBase(1.7, value: Double(multiplier))
        self.level = Int(newLevel) + 1
        // for every level increase
        for _ in (0..<self.level - oldLevel){
            // Increase HP by 20% - 25%
            maxHP += Int(Double(randomNumberBetween(20, end: 26))/100.0 * Double(maxHP))
        }
        // if level increase is to the next tens
        if (self.level % 10) - (oldLevel % 10) > 0{
            // Increase HP by 6 %
            maxHP += Int(0.06 * Double(maxHP))
        }
    }
}
