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
    var fabricMasterLabel = SKLabelNode()
    var mc = Player()
    var mcLabel = SKLabelNode()
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
        
        
        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0)
        recognizer.addModel(PathModel(directions: [7, 1], datas:"A"))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0], datas:"C"))
        self.recognizer = recognizer
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        addBG("bg")
        addPlayer()
        addMonster("fabricMaster1")
        let moveLeft = SKAction.moveTo(CGPoint(x: 270, y: 160), duration: 0.5)
        mc.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), moveLeft])) { () -> Void in
            let movement = SKAction.moveTo(CGPoint(x: self.mc.position.x - 5, y: self.mc.position.y - 5), duration: 2)
            let movement2 = SKAction.moveTo(CGPoint(x: self.mc.position.x + 5, y: self.mc.position.y + 5), duration: 2)
            let sequencer = SKAction.sequence([movement, movement2])
            let repeatAction = SKAction.repeatActionForever(sequencer)
            self.mc.runAction(repeatAction)
        }
        
        
        yourline.strokeColor = SKColor.purpleColor()
        yourline.lineWidth = 20.0
        self.addChild(yourline)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        rawPoints = []
        let touch = touches.first
        let location = touch!.locationInNode(self)
        print(location)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))

        let pathToDraw = CGPathCreateMutable()
        let startLocationX = CGFloat(rawPoints[0])
        let startLocationY = CGFloat(rawPoints[1])
        
        CGPathMoveToPoint(pathToDraw, nil, startLocationX, startLocationY);
        
        for i in 2..<rawPoints.count {
            if i % 2 == 0 {
                let locationX = CGFloat(rawPoints[i])
                let locationY = CGFloat(rawPoints[i + 1])
                CGPathAddLineToPoint(pathToDraw, nil, locationX, locationY);
            }
        }
        
        yourline.path = pathToDraw
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        var path:Path = Path()
        path.addPointFromRaw(rawPoints)
        
        let gesture:PathModel? = self.recognizer!.recognizePath(path)
        
        if gesture != nil {
            let letter = gesture!.datas as? String
            self.userInteractionEnabled = false
            if(letter == "C"){
                guard let skill = mc.skills["wetTowelSlap"] else {
                    return
                }
                let animationNode = skill.animationNode
                
                self.addChild(animationNode)
                skill.animateAction(self, target: fabricMaster, completion: { () -> Void in
                    self.mc.attack(self.fabricMaster, skillName: "wetTowelSlap")
                    self.evaluateGameOver()
                    self.enemyRetaliation()
                    self.evaluateGameOver()
                    self.userInteractionEnabled = true
                })
            }else{
                self.userInteractionEnabled = true
            }
        }
    }
    
    
    
    func addBG(backgroundName: String) {
        let bg = SKSpriteNode(imageNamed: backgroundName)
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
        mainCharacterHealthBar.position = CGPoint(x: 950, y: 130)
        mainCharacterHealthBar.setScale(2.0)
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
        
        mcLabel.text = mc.nameAndHP()
        
        labelDefaultSettings(mcLabel)
        mcLabel.position = CGPoint(x: size.width - (mcLabel.frame.width/2) - 10, y: 0 + (mcLabel.frame.height) + 10)
        addChild(mcLabel)
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
        
        fabricMasterLabel.text = fabricMaster.nameAndHP()
        
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


    func labelDefaultSettings(label: SKLabelNode){
        label.fontColor = SKColor.redColor()
        label.fontSize = 50.0
        label.fontName = "AvenirNext-Bold"
    }
    
    override func update(currentTime: CFTimeInterval) {
        fabricMasterLabel.text = fabricMaster.nameAndHP()
        mcLabel.text = mc.nameAndHP()
        
        mainCharacterLife = CGFloat(Float(fabricMaster.currentHp) / Float(fabricMaster.maxHP) * 2)
        self.enemyLife = CGFloat(Float(self.fabricMaster.currentHp) / Float(self.fabricMaster.maxHP) * 2)
        
        let duration = 1.0
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
