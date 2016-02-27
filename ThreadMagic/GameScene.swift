//
//  GameScene.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/16/16.
//  Copyright (c) 2016 Andrew Chen. All rights reserved.
//


import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var fabricMaster = Monster()
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
    
    var level = 0

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0, costMax: 5)
        
        self.recognizer = recognizer
        
        addBG("bg1")
        addPlayer()
        addEnemy()
        enemyHealthBarHidden(true)
        mcHealthBarHidden(true)
        animateSlideIn()

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
                skill.animateAction(self, caster: mc, target: fabricMaster, completion: { () -> Void in
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
        
        mc.position = CGPoint(x:-280, y: 160)
        mc.xScale = 0.95
        mc.yScale = 0.95

        addChild(mc)
        addPlayerHealthBarLabel()
        
        // add player skills to recognizer
        for (_, skill) in mc.skills{
            recognizer!.addModel(PathModel(directions: skill.gestures, datas: skill.skillName))
        }
        
    }
    
    func addEnemy() {
        let monsterClass = MonsterOrder.order[level]
        fabricMaster = monsterClass.init()
        
        fabricMaster.position = CGPoint(x: size.width + 200, y: size.height - 300)

        addChild(fabricMaster)
        addEnemyHealthBarLabel()
        
    }
    
    func defeated(sprite: SKSpriteNode) {
        let colorize = SKAction.colorizeWithColor(.blueColor(), colorBlendFactor: 1, duration: 0.4)
        let colorNormal = SKAction.colorizeWithColor(.clearColor() , colorBlendFactor: 1, duration: 1.2)
        let colorSequence = SKAction.sequence([colorize, colorNormal])
        sprite.runAction(colorSequence) { () -> Void in
            sprite.removeFromParent()
        }
        
    }
    
    func animateSlideIn() {
        let moveFromRight = SKAction.moveTo(CGPoint(x: size.width - 300, y: size.height - 300), duration: 0.5)
        let moveFromLeft = SKAction.moveTo(CGPoint(x: 270, y: 160), duration: 0.5)
        let clear = SKAction.colorizeWithColor(.clearColor(), colorBlendFactor: 1, duration: 1)
        
        bossThread.runAction(clear)
        fabricMaster.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), moveFromRight])) { () -> Void in
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

    func addEnemyHealthBarLabel() {
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
    
    func addPlayerHealthBarLabel() {
        mainCharacterLife = CGFloat((Float(mc.currentHp) / Float(mc.maxHP)) * 2)
        mainCharacterHealthBar = SKSpriteNode(imageNamed: "healthBar")
        mainCharacterHealthBar.position = CGPoint(x: frame.width - 350, y: frame.height - 700)
        mainCharacterHealthBar.setScale(2.0)
        mainCharacterHealthBar.zPosition = 0.6
        mainCharacterLifeBar = SKSpriteNode(imageNamed: "health")
        mainCharacterLifeBar.position = CGPoint(x: mainCharacterHealthBar.position.x - 172, y: mainCharacterHealthBar.position.y - 1)
        mainCharacterLifeBar.xScale = mainCharacterLife
        mainCharacterLifeBar.yScale = 2.0
        mainCharacterLifeBar.zPosition = 0.5
        mainCharacterLifeBar.anchorPoint = CGPointMake(0.0, 0.5)
        
        
        addChild(mainCharacterHealthBar)
        addChild(mainCharacterLifeBar)
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
            
            skill.animateAction(self, caster: fabricMaster, target: mc, completion: { () -> Void in
                self.fabricMaster.attack(self.mc, skillName: "spiderWeb")
            })
        }
    }
    
    func evaluateGameOver(){
        var scene: GameOverScene!
        if mc.currentHp <= 0 {
            scene = GameOverScene(size: size, won: false)
            scene.nextLevel = level
            scene.mc = mc
            mc.removeFromParent()
        }else if(fabricMaster.currentHp <= 0){
            scene = GameOverScene(size: size, won: true)
            scene.nextLevel = (level + 1) % MonsterOrder.order.count
            scene.mc = mc
            mc.removeFromParent()
        }else{
            return
        }
        scene.scaleMode = scaleMode
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(scene, transition: reveal)
    }
    
    
}
