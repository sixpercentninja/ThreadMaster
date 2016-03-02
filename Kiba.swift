//
//  Kiba.swift
//  ThreadMagic
//
//  Created by Steven Yang on 2/29/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class Kiba: Monster {
    
    let displayImageName = "wolf.png"
    override var expGiven: Int { return 200 }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    override init(imageNamed: String, maxHP: Int, charName: String, attribute: Attribute){
        super.init(imageNamed: imageNamed, maxHP: maxHP, charName: charName, attribute: attribute)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    init(maxHP: Int, charName: String, attribute: Attribute){
        super.init(imageNamed: displayImageName, maxHP: maxHP, charName: charName, attribute: attribute)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    init(){
        super.init(imageNamed: displayImageName, maxHP: 50, charName: "Kiba", attribute: Attribute.Resistance)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignDefaultSkills(){
        self.skills["Aramid One"] = AramidOne()
    }
    
    func settings() {
        setScale(0.5)
        zPosition = 0.4
    }
    
    func animateMonster() {
        let moveDown = SKAction.moveByX(-5, y: 0, duration: 2.0)
        let moveUp = SKAction.moveByX(5, y: 0, duration: 2.0)
        
        let moving = SKAction.sequence([moveDown, moveUp])
        
        let repeatFlying = SKAction.repeatActionForever(moving)
        
        runAction(repeatFlying)
    }
}
