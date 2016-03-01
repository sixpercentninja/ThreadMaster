//
//  BossTwo.swift
//  ThreadMagic
//
//  Created by Steven Yang on 2/27/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//


import Foundation
import SpriteKit

class BossTwo: Monster {
    let displayImageName = "boss2.png"
    
    let bossThread = SKSpriteNode(imageNamed: "boss2Thread.png")
    let bossThread2 = SKSpriteNode(imageNamed: "rightWhip.png")
    let bossThread3 = SKSpriteNode(imageNamed: "leftWhip.png")

    
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
        super.init(imageNamed: displayImageName, maxHP: 50, charName: "Tier", attribute: Attribute.Heat)
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
        setScale(0.5)
        zPosition = 0.4
        
        bossThread.position = CGPoint(x: 0, y: 0)
        bossThread.setScale(1)
        bossThread.zPosition = 0.6
        bossThread2.position = CGPoint(x: bossThread.xScale - 195, y: bossThread.yScale - 280)
        bossThread2.setScale(1)
//        bossThread2.anchorPoint = CGPoint(x: 0.5, y: 1)
        bossThread2.zPosition = 0.5
        bossThread3.position = CGPoint(x: bossThread.xScale + 185, y: bossThread.yScale - 285)
        bossThread3.setScale(1)
        bossThread3.zPosition = 0.5
        addChild(bossThread)
        addChild(bossThread2)
        addChild(bossThread3)

    }
    
    func animateMonster() {
        
        let growingLight = SKAction.scaleXTo(1 + 0.4, y: 1.0 + 0.1, duration: 2)
        let dimmerLight = SKAction.scaleXTo(1.2 - 0.4, y: 1.1 - 0.1, duration: 2)

        let animateAction2 = SKAction.sequence([growingLight, dimmerLight])
        
        let repeatAction2 = SKAction.repeatActionForever(animateAction2)
        bossThread2.runAction(repeatAction2)
        bossThread3.runAction(repeatAction2)
        
    }
}