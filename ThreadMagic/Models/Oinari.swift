//
//  Oinari.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 27/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class Oinari: Monster {
    let displayImageName = "boss3.png"
    let bossThread = SKSpriteNode(imageNamed: "boss3Thread.png")
    override var expGiven: Int { return 12000 }
    
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
        super.init(imageNamed: displayImageName, maxHP: 4050, charName: "Oinari", attribute: Attribute.Pattern)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignDefaultSkills(){
        self.skills["Silk One"] = SilkOne()
        self.skills["Silk Two"] = SilkTwo()
        self.skills["Silk Three"] = SilkThree()
    }
    
    func settings() {
        setScale(0.6)
        zPosition = 0.4
        threadGiven = SilkTrick.self
        
        bossThread.position = CGPoint(x: 0, y: 0)
        bossThread.setScale(1)
        bossThread.zPosition = -1
        addChild(bossThread)
    }
    
    func animateMonster() {
        let moveDownThread = SKAction.moveByX(0, y: -10, duration: 2)
        let moveUpThread = SKAction.moveByX(0, y: 10, duration: 2)
        
        let animateAction = SKAction.sequence([moveUpThread, moveDownThread])
        
        let repeatAction = SKAction.repeatActionForever(animateAction)
        bossThread.runAction(repeatAction)

    }
}