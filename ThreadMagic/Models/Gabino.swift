//
//  Gabino.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 27/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class Gabino: Monster {
    
    let bossThread = SKSpriteNode(imageNamed: "boss1Leg.png")
    let displayImageName = "boss1.png"
    override var expGiven: Int { return 5000 }
    
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
        super.init(imageNamed: displayImageName, maxHP: 450, charName: "Gabino", attribute: Attribute.Resistance)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignDefaultSkills(){
        self.skills["Aramid One"] = AramidOne()
        self.skills["Aramid Two"] = AramidTwo()
        self.skills["Aramid Three"] = AramidThree()
    }
    
    func settings() {
        setScale(0.6)
        zPosition = 0.4
        threadGiven = AramidWard.self
        
        bossThread.position = CGPoint(x: 0, y: 0)
        bossThread.setScale(1)
        bossThread.zPosition = 0.5
        addChild(bossThread)
    }
    
    func animateMonster() {
        let moveDownThread = SKAction.moveByX(-5, y: -10, duration: 2)
        let moveUpThread = SKAction.moveByX(5, y: 10, duration: 2)
        
        let animateAction = SKAction.sequence([moveUpThread, moveDownThread])
        
        let repeatAction = SKAction.repeatActionForever(animateAction)
        runAction(repeatAction)
        
    }
}