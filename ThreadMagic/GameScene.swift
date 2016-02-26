//
//  GameScene.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/16/16.
//  Copyright (c) 2016 Andrew Chen. All rights reserved.
//


import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var fabricMaster = FabricMaster()
    var leftWing = SKSpriteNode()
    var rightWing = SKSpriteNode()
    var bossThread = SKSpriteNode()
    var fabricMasterLabel = SKLabelNode()
    var mc = Player()
    var mcLabel = SKLabelNode()
    var mcName = SKLabelNode()
    var mainCharacterHealthBar = SKSpriteNode()
    var mainCharacterLifeBar = SKSpriteNode()
    var mainCharacterLife = CGFloat()
    var enemyHealthBar = SKSpriteNode()
    var enemyLifeBar = SKSpriteNode()
    var enemyLife = CGFloat()
    
    var rawPoints:[Int] = []
    var recognizer: DBPathRecognizer?
    
    var yourline: SKShapeNode = SKShapeNode()

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0, costMax: 5)
        
//        //Cotton
//        recognizer.addModel(PathModel(directions: [7], datas:"C"))
//        recognizer.addModel(PathModel(directions: [7,1], datas:"CBlaze"))
//        recognizer.addModel(PathModel(directions: [7,1,4], datas:"WildFire"))
//        
//        //Silk
//        recognizer.addModel(PathModel(directions: [0,1,2,3,4,5,6,7], datas:"STrick"))
//        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5], datas:"SDaze"))
//        recognizer.addModel(PathModel(directions: [0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7], datas:"PieceDeResistance"))
//        
//        //Aramid
//        recognizer.addModel(PathModel(directions: [2], datas:"AWard"))
//        recognizer.addModel(PathModel(directions: [2,6], datas:"AGuard"))
//        recognizer.addModel(PathModel(directions: [2,6,2], datas:"AegisLastStand"))
//        
//        //Rayon
//        recognizer.addModel(PathModel(directions: [3], datas:"RStrike"))
//        recognizer.addModel(PathModel(directions: [3,5], datas:"RBash"))
//        recognizer.addModel(PathModel(directions: [1,6,3], datas:"KusanagiNoTsurugi"))
        
        
        self.recognizer = recognizer
        
        addBG("bg1")
        addPlayer()
        
//        addMonster("fabricMaster1")
//        addDragon()
//        addBoss1()
//        addBoss3()
        addBoss4()
        enemyHealthBarHidden(true)
        mcHealthBarHidden(true)
        
        let moveFromRight = SKAction.moveTo(CGPoint(x: size.width - 300, y: size.height - 300), duration: 0.5)
        let moveFromLeft = SKAction.moveTo(CGPoint(x: 270, y: 160), duration: 0.5)
        let clear = SKAction.colorizeWithColor(.clearColor(), colorBlendFactor: 1, duration: 1)
        
        bossThread.runAction(clear)
        fabricMaster.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), moveFromRight])) { () -> Void in
                self.bossThread.runAction(moveFromRight) { () -> Void in

                    self.bossThread.runAction(clear.reversedAction())
                    self.enemyHealthBarHidden(false)
                self.mc.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), moveFromLeft])) { () -> Void in
                    let movement = SKAction.moveTo(CGPoint(x: self.mc.position.x - 5, y: self.mc.position.y - 5), duration: 2)
                    let movement2 = SKAction.moveTo(CGPoint(x: self.mc.position.x + 5, y: self.mc.position.y + 5), duration: 2)
                    let waitTime = SKAction.waitForDuration(0.4)
                    let sequencer = SKAction.sequence([movement, movement2])
                    let repeatAction = SKAction.repeatActionForever(sequencer)
                    self.mc.runAction(repeatAction)
                    self.mc.runAction(waitTime){ () -> Void in
                    self.mcHealthBarHidden(false)
                    }

                }
            }
        }
        
        
        
        
        let magic = SKTexture(imageNamed: "FireBeam")
        
        yourline.lineWidth = 50.0
        yourline.glowWidth = 3.0
        yourline.strokeTexture = magic
        yourline.zPosition = 2
        addChild(yourline)
        
    }
    

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        rawPoints = []
        let touch = touches.first
        let location = touch!.locationInNode(self)
        print(location)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(size.height - location.y))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(size.height - location.y))

        let pathToDraw = CGPathCreateMutable()
        let startLocationX = CGFloat(rawPoints[0])
        let startLocationY = CGFloat(rawPoints[1])
        
        CGPathMoveToPoint(pathToDraw, nil, startLocationX, size.height - startLocationY);
        
        for i in 2..<rawPoints.count {
            if i % 2 == 0 {
                let locationX = CGFloat(rawPoints[i])
                let locationY = CGFloat(rawPoints[i + 1])
                CGPathAddLineToPoint(pathToDraw, nil, locationX, size.height - locationY);
            }
        }
        
        yourline.path = pathToDraw
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.userInteractionEnabled = false
        var path:Path = Path()
        path.addPointFromRaw(rawPoints)
        
        let gesture:PathModel? = self.recognizer!.recognizePath(path)
        
        if gesture != nil {
            let castedSpell = gesture!.datas as! String
            print(castedSpell)
            
            if let skill = mc.skills[castedSpell]{
                let animationNode = skill.animationNode
                
                self.addChild(animationNode)
                skill.animateAction(self, target: fabricMaster, completion: { () -> Void in
                    self.mc.attack(self.fabricMaster, skillName: skill.skillName)
                    self.evaluateGameOver()
                    self.enemyRetaliation()
                    self.evaluateGameOver()
                })
            }
        }
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.yourline.path = CGPathCreateMutable()
            self.userInteractionEnabled = true
        })
    }
    
    
    
    func addBG(backgroundName: String) {
        let bg = SKSpriteNode(imageNamed: backgroundName)
        bg.name = "bg"
        bg.zPosition = -1
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(bg)
    }
    
    func addPlayer() {
        let textureAtlas = SKTextureAtlas(named: "mainCharacter")
        
        let mcArray = textureAtlas.textureNames.map({ textureAtlas.textureNamed($0) })
        
        mc = Player(imageNamed: textureAtlas.textureNames.first!, maxHP: 50, charName: "Steven", attribute: Attribute.Neutral)

        mc.position = CGPoint(x:-280, y: 160)
        mc.xScale = 0.95
        mc.yScale = 0.95
        mainCharacterLife = CGFloat((Float(mc.currentHp) / Float(mc.maxHP)) * 2)
        mainCharacterHealthBar = SKSpriteNode(imageNamed: "healthBar")
        mainCharacterHealthBar.position = CGPoint(x: frame.width - 350, y: frame.height - 700)
        mainCharacterHealthBar.setScale(2.0)
//        mainCharacterHealthBar.xScale = 2.0
//        mainCharacterHealthBar.yScale = 1.5
        mainCharacterHealthBar.zPosition = 0.6
        mainCharacterLifeBar = SKSpriteNode(imageNamed: "health")
        mainCharacterLifeBar.position = CGPoint(x: mainCharacterHealthBar.position.x - 172, y: mainCharacterHealthBar.position.y - 1)
        mainCharacterLifeBar.xScale = mainCharacterLife
        mainCharacterLifeBar.yScale = 2.0
        mainCharacterLifeBar.zPosition = 0.5
        mainCharacterLifeBar.anchorPoint = CGPointMake(0.0, 0.5)

        
        addChild(mc)
        addChild(mainCharacterHealthBar)
        addChild(mainCharacterLifeBar)
        
        let animateAction = SKAction.animateWithTextures(mcArray, timePerFrame: 0.30)
        let repeatAction = SKAction.repeatActionForever(animateAction)
        mc.runAction(repeatAction)
        
        mcLabel.text = mc.hP()
        mcName.text = mc.theName()
        mcLabel.zPosition = 0.7
        mcName.zPosition = 0.7
        labelDefaultSettings(mcLabel)
        labelDefaultSettings(mcName)
        mcLabel.position = CGPoint(x: mainCharacterHealthBar.position.x + 20, y: mainCharacterHealthBar.position.y - 19)
        mcName.position = CGPoint(x: mainCharacterHealthBar.position.x - 120, y: mainCharacterHealthBar.position.y + 35)
        addChild(mcLabel)
        addChild(mcName)
        
        // add player skills to recognizer
        for (_, skill) in mc.skills{
            recognizer!.addModel(PathModel(directions: skill.gestures, datas: skill.skillName))
        }
        
    }
    
    func addBoss4() {
        
        
        fabricMaster = FabricMaster(imageNamed: "boss4.png", maxHP: 2100, charName: "Alistair", attribute: Attribute.Heat)
        fabricMaster.position = CGPoint(x: size.width + 200, y: size.height - 300)
        fabricMaster.setScale(0.4)
        fabricMaster.zPosition = 0.4
        
        bossThread = SKSpriteNode(imageNamed: "boss4Thread.png")
        bossThread.position = CGPoint(x: fabricMaster.position.x, y: fabricMaster.position.y)
        bossThread.setScale(0.5)
        bossThread.zPosition = fabricMaster.zPosition - 0.1
        
        addChild(fabricMaster)
        addChild(bossThread)
        
        let moveDownThread = SKAction.moveToY(fabricMaster.position.y - 20, duration: 2)
        let moveUpThread = SKAction.moveToY(fabricMaster.position.y + 20, duration: 2)
        let moveDown = SKAction.moveToY(fabricMaster.position.y - 5, duration: 3)
        let moveUp = SKAction.moveToY(fabricMaster.position.y + 5, duration: 3)
        let flying = SKAction.sequence([moveDown, moveUp])
        
        let animateAction = SKAction.sequence([moveUpThread, moveDownThread])
        
        let repeatAction = SKAction.repeatActionForever(animateAction)
        let repeatFlying = SKAction.repeatActionForever(flying)
        bossThread.runAction(repeatAction)
        fabricMaster.runAction(repeatFlying)
        
        enemyLife = CGFloat((fabricMaster.currentHp / fabricMaster.maxHP) * 2)
        enemyHealthBar = SKSpriteNode(imageNamed: "healthBar")
        enemyHealthBar.position = CGPoint(x: size.width - 925, y: size.height - 145)
        enemyHealthBar.zPosition = 0.6
        enemyHealthBar.setScale(2.0)
        enemyHealthBar.xScale = 2.0
        enemyHealthBar.yScale = 1.5
        enemyLifeBar = SKSpriteNode(imageNamed: "health")
        enemyLifeBar.position = CGPoint(x: enemyHealthBar.position.x - 172, y: enemyHealthBar.position.y - 1)
        enemyLifeBar.anchorPoint = CGPointMake(0.0, 0.5)
        enemyLifeBar.zPosition = 0.5
        enemyLifeBar.xScale = enemyLife
        enemyLifeBar.yScale = 1.5
        addChild(enemyHealthBar)
        addChild(enemyLifeBar)
        
        fabricMasterLabel.text = fabricMaster.theName()
        
        labelDefaultSettings(fabricMasterLabel)
        
        fabricMasterLabel.position = CGPoint(x: enemyHealthBar.position.x - 100, y: fabricMaster.position.y + 190)
        addChild(fabricMasterLabel)
    }

    func addBoss3() {
        
        
        fabricMaster = FabricMaster(imageNamed: "boss3.png", maxHP: 2100, charName: "Tier", attribute: Attribute.Heat)
        fabricMaster.position = CGPoint(x: size.width + 200, y: size.height - 300)
        fabricMaster.setScale(0.6)
        fabricMaster.zPosition = 0.4
        
        bossThread = SKSpriteNode(imageNamed: "boss3Thread.png")
        bossThread.position = CGPoint(x: fabricMaster.position.x, y: fabricMaster.position.y + 20)
        bossThread.setScale(0.6)
        bossThread.zPosition = fabricMaster.zPosition - 0.1
        
        addChild(fabricMaster)
        addChild(bossThread)
        
        let moveDownThread = SKAction.moveToY(bossThread.position.y - 10, duration: 2)
        let moveUpThread = SKAction.moveToY(bossThread.position.y + 10, duration: 2)
        
        let animateAction = SKAction.sequence([moveUpThread, moveDownThread])
        
        let repeatAction = SKAction.repeatActionForever(animateAction)

        bossThread.runAction(repeatAction)
        
        enemyLife = CGFloat((fabricMaster.currentHp / fabricMaster.maxHP) * 2)
        enemyHealthBar = SKSpriteNode(imageNamed: "healthBar")
        enemyHealthBar.position = CGPoint(x: size.width - 875, y: size.height - 145)
        enemyHealthBar.zPosition = 0.6
        enemyHealthBar.setScale(2.0)
        enemyHealthBar.xScale = 2.0
        enemyHealthBar.yScale = 1.5
        enemyLifeBar = SKSpriteNode(imageNamed: "health")
        enemyLifeBar.position = CGPoint(x: enemyHealthBar.position.x - 172, y: enemyHealthBar.position.y - 1)
        enemyLifeBar.anchorPoint = CGPointMake(0.0, 0.5)
        enemyLifeBar.zPosition = 0.5
        enemyLifeBar.xScale = enemyLife
        enemyLifeBar.yScale = 1.5
        addChild(enemyHealthBar)
        addChild(enemyLifeBar)
        
        fabricMasterLabel.text = fabricMaster.theName()
        
        labelDefaultSettings(fabricMasterLabel)
        
        fabricMasterLabel.position = CGPoint(x: enemyHealthBar.position.x - 100, y: fabricMaster.position.y + 190)
        addChild(fabricMasterLabel)
    }

    func addBoss1() {
        bossThread = SKSpriteNode(imageNamed: "boss1Leg.png")
        bossThread.position = CGPoint(x: size.width - 250, y: size.height - 300)
        bossThread.setScale(0.6)
        bossThread.zPosition = 0.5
        
        fabricMaster = FabricMaster(imageNamed: "boss1.png", maxHP: 2100, charName: "Tier", attribute: Attribute.Heat)
        fabricMaster.position = CGPoint(x: bossThread.position.x, y: bossThread.position.y - 40)
        fabricMaster.setScale(0.6)
        fabricMaster.zPosition = 0.4
        addChild(bossThread)
        addChild(fabricMaster)
        let moveDownThread = SKAction.moveToY(bossThread.position.y - 5, duration: 2)
        let moveUpThread = SKAction.moveToY(bossThread.position.y + 5, duration: 2)
        let animateAction = SKAction.sequence([moveUpThread, moveDownThread])
        let repeatAction = SKAction.repeatActionForever(animateAction)
        fabricMaster.runAction(repeatAction)
        
        enemyLife = CGFloat((fabricMaster.currentHp / fabricMaster.maxHP) * 2)
        enemyHealthBar = SKSpriteNode(imageNamed: "healthBar")
        enemyHealthBar.position = CGPoint(x: size.width - 975, y: size.height - 145)
        enemyHealthBar.zPosition = 0.6
        enemyHealthBar.setScale(2.0)
        enemyHealthBar.xScale = 2.0
        enemyHealthBar.yScale = 1.5
        enemyLifeBar = SKSpriteNode(imageNamed: "health")
        enemyLifeBar.position = CGPoint(x: enemyHealthBar.position.x - 172, y: enemyHealthBar.position.y - 1)
        enemyLifeBar.anchorPoint = CGPointMake(0.0, 0.5)
        enemyLifeBar.zPosition = 0.5
        enemyLifeBar.xScale = enemyLife
        enemyLifeBar.yScale = 1.5
        addChild(enemyHealthBar)
        addChild(enemyLifeBar)
        
        fabricMasterLabel.text = fabricMaster.theName()
        
        labelDefaultSettings(fabricMasterLabel)
        
        fabricMasterLabel.position = CGPoint(x: enemyHealthBar.position.x - 100, y: fabricMaster.position.y + 190)
        addChild(fabricMasterLabel)
    }
    
    func addDragon() {
        
        
        fabricMaster = FabricMaster(imageNamed: "dragonBody", maxHP: 2100, charName: "Cuadsf", attribute: Attribute.Heat)
        fabricMaster.position = CGPoint(x: 940, y: 570)
        fabricMaster.setScale(0.8)
        fabricMaster.zPosition = 0.4
        rightWing = SKSpriteNode(imageNamed: "dragonRightWing")
        rightWing.anchorPoint = CGPoint(x: 1, y: 0.5)
        rightWing.position = CGPoint(x: fabricMaster.position.x - 20, y: fabricMaster.position.y + 40)
        rightWing.setScale(0.6)
        rightWing.zRotation = CGFloat(M_PI) / 3
        rightWing.zPosition = fabricMaster.zPosition - 0.1
        
        leftWing = SKSpriteNode(imageNamed: "dragonLeftWing")
        leftWing.anchorPoint = CGPoint(x: 0.1, y: 0.5)
        leftWing.position = CGPoint(x: fabricMaster.position.x + 70, y: fabricMaster.position.y + 45)
        leftWing.setScale(0.7)
        leftWing.zRotation = CGFloat(M_PI) / -3
        leftWing.zPosition = fabricMaster.zPosition + 0.1
        
        addChild(fabricMaster)
        addChild(rightWing)
        addChild(leftWing)
        
        let rotateUp = SKAction.rotateByAngle(1.8, duration: 0.6)
        let rotateDown = SKAction.rotateByAngle(-1.8, duration: 1.2)
        let rotateUpReverse = SKAction.rotateByAngle(-1.8, duration: 0.6)
        let rotateDownReverse = SKAction.rotateByAngle(1.8, duration: 1.2)
        let moveDown = SKAction.moveToY(fabricMaster.position.y - 30, duration: 0.6)
        let moveUp = SKAction.moveToY(fabricMaster.position.y + 30, duration: 1.2)
        let flying = SKAction.sequence([moveDown, moveUp])
        
        let animateAction = SKAction.sequence([rotateUp, rotateDown])
        let animateActionReverse = SKAction.sequence([rotateUpReverse, rotateDownReverse])
        
        let repeatAction = SKAction.repeatActionForever(animateAction)
        let repeatActionReverse = SKAction.repeatActionForever(animateActionReverse)
        let repeatFlying = SKAction.repeatActionForever(flying)
        leftWing.runAction(repeatAction)
        rightWing.runAction(repeatActionReverse)
        fabricMaster.runAction(repeatFlying)
        
        enemyLife = CGFloat((fabricMaster.currentHp / fabricMaster.maxHP) * 2)
        enemyHealthBar = SKSpriteNode(imageNamed: "healthBar")
        enemyHealthBar.position = CGPoint(x: size.width - 975, y: size.height - 125)
        enemyHealthBar.zPosition = 0.6
        enemyHealthBar.setScale(2.0)
        enemyLifeBar = SKSpriteNode(imageNamed: "health")
        enemyLifeBar.position = CGPoint(x: enemyHealthBar.position.x - 172, y: enemyHealthBar.position.y - 1)
        enemyLifeBar.anchorPoint = CGPointMake(0.0, 0.5)
        enemyLifeBar.zPosition = 0.5
        enemyLifeBar.xScale = enemyLife
        enemyLifeBar.yScale = 2.0
        addChild(enemyHealthBar)
        addChild(enemyLifeBar)
    }

    
    func addMonster(atlasName: String) {
        let textureAtlas = SKTextureAtlas(named: atlasName)
        fabricMaster.textureAtlas = textureAtlas
        
        let fabricMasterArray = textureAtlas.textureNames.map({ textureAtlas.textureNamed($0) })
        
        fabricMaster = FabricMaster(imageNamed: textureAtlas.textureNames.first!, maxHP: 100, charName: "Cuadsf", attribute: Attribute.Heat)
        
        fabricMaster.position = CGPoint(x: 940, y: 520)
        

        addChild(fabricMaster)
        //Life
        enemyLife = CGFloat((fabricMaster.currentHp / fabricMaster.maxHP) * 2)
        enemyHealthBar = SKSpriteNode(imageNamed: "healthBar")
        enemyHealthBar.position = CGPoint(x: 350, y: 650)
        enemyHealthBar.zPosition = 0.6
        enemyHealthBar.setScale(2.0)
        enemyLifeBar = SKSpriteNode(imageNamed: "health")
        enemyLifeBar.position = CGPoint(x: enemyHealthBar.position.x - 172, y: enemyHealthBar.position.y - 1)
        enemyLifeBar.anchorPoint = CGPointMake(0.0, 0.5)
        enemyLifeBar.zPosition = 0.5
        enemyLifeBar.xScale = enemyLife
        enemyLifeBar.yScale = 2.0
        addChild(enemyHealthBar)
        addChild(enemyLifeBar)
        
        
        let animateAction = SKAction.animateWithTextures(fabricMasterArray, timePerFrame: 0.30)
        let repeatAction = SKAction.repeatActionForever(animateAction)
        
        fabricMaster.runAction(repeatAction)
        
        fabricMasterLabel.text = fabricMaster.theName()
        
        labelDefaultSettings(fabricMasterLabel)
        
        fabricMasterLabel.position = CGPoint(x: 0 + (fabricMasterLabel.frame.width/2) + 10, y: size.height - (fabricMasterLabel.frame.height) - 50)
        addChild(fabricMasterLabel)
    }
    
    
    func defeated(sprite: SKSpriteNode) {
        let colorize = SKAction.colorizeWithColor(.blueColor(), colorBlendFactor: 1, duration: 0.4)
        let colorNormal = SKAction.colorizeWithColor(.clearColor() , colorBlendFactor: 1, duration: 1.2)
        let colorSequence = SKAction.sequence([colorize, colorNormal])
        sprite.runAction(colorSequence) { () -> Void in
            sprite.removeFromParent()
        }
        
    }

    
    func enemyHealthBarHidden (isHidden: Bool) {
        enemyHealthBar.hidden = isHidden
        enemyLifeBar.hidden = isHidden
        fabricMasterLabel.hidden = isHidden
    }
    
    func mcHealthBarHidden (isHidden: Bool) {
        mainCharacterHealthBar.hidden = isHidden
        mainCharacterLifeBar.hidden = isHidden
        mcLabel.hidden = isHidden
        mcName.hidden = isHidden
    }

    func labelDefaultSettings(label: SKLabelNode){
        label.fontColor = SKColor.blackColor()
        label.fontSize = 50.0
        label.fontName = "AvenirNext-Bold"
    }
    
    override func update(currentTime: CFTimeInterval) {
        mcLabel.text = mc.theName()
        mcLabel.text = mc.hP()
        
        mainCharacterLife = CGFloat(Float(mc.currentHp) / Float(mc.maxHP) * 2)
        self.enemyLife = CGFloat(Float(self.fabricMaster.currentHp) / Float(self.fabricMaster.maxHP) * 2)
        
        let duration = 0.4
        let enemyLifeDrop = SKAction.scaleXTo(enemyLife, duration: duration)
        enemyLifeBar.runAction(enemyLifeDrop) { () -> Void in
            self.enemyLifeBar.xScale = self.enemyLife
        }
        let mainCharacterLifeDrop = SKAction.scaleXTo(mainCharacterLife, duration: duration)
        mainCharacterLifeBar.runAction(mainCharacterLifeDrop) { () -> Void in
            self.mainCharacterLifeBar.xScale = self.mainCharacterLife
        }
    }
    
    func enemyRetaliation(){
        if let skill = self.fabricMaster.skills["spiderWeb"] {
            
            skill.animateAction(self, target: mc, completion: { () -> Void in
                self.fabricMaster.attack(self.mc, skillName: "spiderWeb")
            })
        }
    }
    
    func evaluateGameOver(){
        var scene: GameOverScene!
        if mc.currentHp <= 0 {
            scene = GameOverScene(size: size, won: false)
        }else if(fabricMaster.currentHp <= 0){
            scene = GameOverScene(size: size, won: true)
        }else{
            return
        }
        scene.scaleMode = scaleMode
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(scene, transition: reveal)
    }
    
    
}
