//
//  Charon.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 26/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class Charon: Monster {
    
    let bossThread = SKSpriteNode(imageNamed: "boss4Thread.png")
    let displayImageName = "boss4.png"
    override var expGiven: Int { return 15000 }
    
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
        super.init(imageNamed: displayImageName, maxHP: 1550, charName: "Charon", attribute: Attribute.Strength)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignDefaultSkills(){
        self.skills["Rayon One"] = RayonOne()
        self.skills["Rayon Two"] = RayonTwo()
        self.skills["Rayon Three"] = RayonThree()
    }
    
    func settings() {
        setScale(0.4)
        zPosition = 0.4
        
        threadGiven = RayonStrike.self
        
        bossThread.position = CGPoint(x: 0, y: 0)
        bossThread.setScale(1.25)
        bossThread.zPosition = -1
        addChild(bossThread)
    }
    
    func animateMonster() {
        let moveDownThread = SKAction.moveByX(0, y: -20, duration: 2)
        let moveUpThread = SKAction.moveByX(0, y: 20, duration: 2)
        let moveDown = SKAction.moveByX(0, y: -5, duration: 2)
        let moveUp = SKAction.moveByX(0, y: 5, duration: 2)
        let flying = SKAction.sequence([moveDown, moveUp])
        
        let animateAction = SKAction.sequence([moveUpThread, moveDownThread])
        
        let repeatAction = SKAction.repeatActionForever(animateAction)
        let repeatFlying = SKAction.repeatActionForever(flying)
        bossThread.runAction(repeatAction)
        runAction(repeatFlying)
    }
}