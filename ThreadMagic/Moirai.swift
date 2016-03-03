//
//  Moirai.swift
//  ThreadMagic
//
//  Created by Steven Yang on 3/1/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//


import Foundation
import SpriteKit

class Moirai: Monster {
    let displayImageName = "MoiraiBody.png"
    
    let bossThread = SKSpriteNode(imageNamed: "MoiraiThread.png")
    let bossThread2 = SKSpriteNode(imageNamed: "MoiraiAura.png")
    override var expGiven: Int { return 25000 }
    
    
    
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
        super.init(imageNamed: displayImageName, maxHP: 12500, charName: "Aisa", attribute: Attribute.Neutral)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignDefaultSkills(){
        self.skills["Aramid Three"] = AramidThree()
        self.skills["Cotton Three"] = CottonThree()
        self.skills["Silk Three"] = SilkThree()
        self.skills["Rayon Three"] = RayonThree()
        self.skills["Ultimate Two"] = UltimateTwo()
        self.skills["Ultimate Three"] = UltimateThree()
        
    }
    
    func settings() {
        setScale(0.4)
        zPosition = 1
        
        bossThread.position = CGPoint(x: 50, y: 150)
        bossThread.setScale(1)
        bossThread.zPosition = -1
        bossThread2.position = CGPoint(x: 0, y: 0)
        bossThread2.setScale(1)
        bossThread2.zPosition = -0.5
        addChild(bossThread)
        addChild(bossThread2)
        
    }
    
    func animateMonster() {
        
        let growingLight = SKAction.scaleXTo(1.0 + 0.1, y: 1.0 + 0.1, duration: 2)
        let dimmerLight = SKAction.scaleXTo(1.1 - 0.1, y: 1.1 - 0.1, duration: 2)
        
        let rotater = SKAction.rotateByAngle(5.0, duration: 5)
        
        let animateAction2 = SKAction.sequence([growingLight, dimmerLight])
        
        let repeatAction = SKAction.repeatActionForever(rotater)
        let repeatAction2 = SKAction.repeatActionForever(animateAction2)
        bossThread2.runAction(repeatAction2)
        bossThread.runAction(repeatAction)
    }
}