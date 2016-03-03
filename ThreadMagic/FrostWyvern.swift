//
//  FrostWyvern.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 27/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit

class FrostWyvern: Monster {
    
    let rightWing = SKSpriteNode(imageNamed: "dragonRightWing")
    let leftWing = SKSpriteNode(imageNamed: "dragonLeftWing")
    let displayImageName = "dragonBody"
    override var expGiven: Int { return 1000 }
    
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
        super.init(imageNamed: displayImageName, maxHP: 300, charName: "Frost Wyvern", attribute: Attribute.Heat)
        settings()
        animateMonster()
        assignDefaultSkills()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignDefaultSkills(){
        self.skills["Silk One"] = SilkOne()
    }
    
    func settings() {
        setScale(0.8)
        zPosition = 0.4
        
        rightWing.anchorPoint = CGPoint(x: 1, y: 0.5)
        rightWing.position = CGPoint(x: -35, y: 40)
        rightWing.setScale(0.6)
        rightWing.zRotation = CGFloat(M_PI) / 3
        rightWing.zPosition = -1
        
        leftWing.anchorPoint = CGPoint(x: 0.1, y: 0.5)
        leftWing.position = CGPoint(x: 85, y: 45)
        leftWing.setScale(0.7)
        leftWing.zRotation = CGFloat(M_PI) / -3
        leftWing.zPosition = 0.5
        
        addChild(rightWing)
        addChild(leftWing)
    }
    
    func animateMonster() {
        let rotateUp = SKAction.rotateByAngle(1.8, duration: 0.6)
        let rotateDown = SKAction.rotateByAngle(-1.8, duration: 1.2)
        let rotateUpReverse = SKAction.rotateByAngle(-1.8, duration: 0.6)
        let rotateDownReverse = SKAction.rotateByAngle(1.8, duration: 1.2)
        let moveDown = SKAction.moveByX(0, y: -30, duration: 0.6)
        let moveUp = SKAction.moveByX(0, y: 30, duration: 1.2)
        
        let flying = SKAction.sequence([moveDown, moveUp])
        
        let animateAction = SKAction.sequence([rotateUp, rotateDown])
        let animateActionReverse = SKAction.sequence([rotateUpReverse, rotateDownReverse])
        
        let repeatAction = SKAction.repeatActionForever(animateAction)
        let repeatActionReverse = SKAction.repeatActionForever(animateActionReverse)
        let repeatFlying = SKAction.repeatActionForever(flying)
        
        leftWing.runAction(repeatAction)
        rightWing.runAction(repeatActionReverse)
        runAction(repeatFlying)
    }
}