//
//  BossOne.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 27/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class BossOne: Monster {
    
    let bossThread = SKSpriteNode(imageNamed: "boss1Leg.png")
    let displayImageName = "boss1.png"
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        expGiven = 25
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
        super.init(imageNamed: displayImageName, maxHP: 50, charName: "BossOne", attribute: Attribute.Heat)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignDefaultSkills(){
        self.skills["spiderWeb"] = SpiderWeb()
    }
    
    func settings() {
        setScale(0.6)
        zPosition = 0.4
        
        bossThread.position = CGPoint(x: 0, y: -40)
        bossThread.setScale(1)
        bossThread.zPosition = -1
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