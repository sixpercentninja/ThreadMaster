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
//    var leftWing = SKSpriteNode()
//    var rightWing = SKSpriteNode()
    var bossThread = SKSpriteNode()
    var fabricMasterLabel = SKLabelNode()

    var mc = Player.mainPlayer
    var mcHpLabel = SKLabelNode()

    var mcName = SKLabelNode()
    var mcLevelLabel = SKLabelNode()
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
    
    var spellBookButton = SKSpriteNode()
    var cancelButton = SKSpriteNode()
    var forwardArrow = SKSpriteNode()
    var backArrow = SKSpriteNode()
    let physicalLabel = SKLabelNode()
    var physicalSpellOne = SKLabelNode()
    var physicalSpellTwo = SKLabelNode()
    var physicalSpellThree = SKLabelNode()
    let aramidLabel = SKLabelNode()
    var aramidSpellOne = SKLabelNode()
    var aramidSpellTwo = SKLabelNode()
    var aramidSpellThree = SKLabelNode()
    let cottonLabel = SKLabelNode()
    var cottonSpellOne = SKLabelNode()
    var cottonSpellTwo = SKLabelNode()
    var cottonSpellThree = SKLabelNode()
    let silkLabel = SKLabelNode()
    var silkSpellOne = SKLabelNode()
    var silkSpellTwo = SKLabelNode()
    var silkSpellThree = SKLabelNode()
    let rayonLabel = SKLabelNode()
    var rayonSpellOne = SKLabelNode()
    var rayonSpellTwo = SKLabelNode()
    var rayonSpellThree = SKLabelNode()
    let labelArray = [SKLabelNode()]

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        SKTAudio.sharedInstance().playBackgroundMusic("Desert Battle (Loop).mp3")

        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0, costMax: 5)
        
        self.recognizer = recognizer
        
        addBG("bg1")
        addPlayer()
        addEnemy(0)
        addSpellBook()
        enemyHealthBarHidden(true)
        mcHealthBarHidden(true)
        animateSlideIn()

        let magic = SKTexture(imageNamed: "FireBeam")
        
        yourline.lineWidth = 50.0
        yourline.glowWidth = 3.0
        yourline.strokeTexture = magic
        yourline.zPosition = 2
        addChild(yourline)

        spellBookButton.name = "spellBookButton"
        spellBookButton.userInteractionEnabled = false
        cancelButton.name = "cancelButton"
        cancelButton.userInteractionEnabled = false
        forwardArrow.name = "forwardArrow"
        forwardArrow.userInteractionEnabled = false
        backArrow.name = "backArrow"
        backArrow.userInteractionEnabled = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        rawPoints = []
        let touch = touches.first
        let location = touch!.locationInNode(self)
        print(location)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(size.height - location.y))
        
        
        let positionInScene = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "spellBookButton"
            {
                let moveToMiddle = SKAction.moveTo(CGPoint(x: size.width / 2, y: size.height / 2), duration: 0.8)
                let waitDuration = SKAction.waitForDuration(0.8)
                let growBigger = SKAction.scaleTo(0.8, duration: 0.8)
                let sequence = SKAction.sequence([moveToMiddle, waitDuration])
                spellBookButton.runAction(growBigger)
                spellBookButton.runAction(sequence) { () -> Void in
//                    self.spellBookButton.texture = SKTexture(imageNamed: "SpellBook.png")
                    self.spellBookButton.removeFromParent()
                    self.addSpellBookOpen()
                    self.cancelButton.name = "cancelButton"
                    self.cancelButton.userInteractionEnabled = false
                    self.forwardArrow.name = "forwardArrow"
                    self.forwardArrow.userInteractionEnabled = false
                }
            }
            else if name == "cancelButton" {
                removeAllObjects()
                addSpellBook()
                spellBookButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
                spellBookButton.setScale(0.8)
                let moveToBack = SKAction.moveTo(CGPoint(x: size.width - 1225, y: size.height - 700), duration: 0.8)
                let growSmaller = SKAction.scaleTo(0.1, duration: 0.8)
                let waitDuration = SKAction.waitForDuration(0.8)
                spellBookButton.runAction(waitDuration) { () -> Void in
                    self.spellBookButton.runAction(moveToBack)
                    self.spellBookButton.runAction(growSmaller)
                    self.spellBookButton.name = "spellBookButton"
                    self.spellBookButton.userInteractionEnabled = false
                }

            }
            else if name == "forwardArrow" {
                removeAllObjects()
                addSpellBookOpenPgTwo()
                backArrow.name = "backArrow"
                backArrow.userInteractionEnabled = false
                cancelButton.name = "cancelButton"
                cancelButton.userInteractionEnabled = false
            }
            
            else if name == "backArrow" {
                removeAllObjects()
                addSpellBookOpen()
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
                self.forwardArrow.name = "forwardArrow"
                self.forwardArrow.userInteractionEnabled = false
            }
        }
        
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
        
        mc.position = CGPoint(x: frame.width - 1540, y: frame.height - 640)
        mc.xScale = 0.95
        mc.yScale = 0.95

        addChild(mc)
        addPlayerHealthBarLabel()
        
        // add player skills to recognizer
        for (_, skill) in mc.skills{
            recognizer!.addModel(PathModel(directions: skill.gestures, datas: skill.skillName))
        }
        
    }
    
    func addEnemy(bossOrderNumber: Int) {
        let monsterClass = MonsterOrder.order[bossOrderNumber]
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
        let moveRight = SKAction.moveTo(CGPoint(x: frame.width - 300, y: frame.height - 300), duration: 0.5)
        let moveLeft = SKAction.moveTo(CGPoint(x: frame.width - 1010, y: frame.height - 640), duration: 0.5)
        let clear = SKAction.colorizeWithColor(.clearColor(), colorBlendFactor: 1, duration: 1)
        
        bossThread.runAction(clear)
        fabricMaster.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), moveRight])) { () -> Void in
            self.enemyHealthBarHidden(false)
            self.mc.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), moveLeft])) { () -> Void in
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
        enemyLife = CGFloat(fabricMaster.currentHp / fabricMaster.maxHP)
        enemyHealthBar = SKSpriteNode(imageNamed: "enemyHealthBar.png")
        enemyHealthBar.position = CGPoint(x: size.width - 925, y: size.height - 145)
        enemyHealthBar.zPosition = 0.5
        enemyHealthBar.setScale(1.0)
        enemyHealthBar.xScale = 1.0
        enemyHealthBar.yScale = 1.0
        enemyLifeBar = SKSpriteNode(imageNamed: "health2.png")
        enemyLifeBar.position = CGPoint(x: enemyHealthBar.position.x - 162, y: enemyHealthBar.position.y - 11)
        enemyLifeBar.zPosition = enemyHealthBar.zPosition + 0.1
        enemyLifeBar.anchorPoint = CGPointMake(0.0, 0.5)
        enemyLifeBar.xScale = enemyLife
        enemyLifeBar.yScale = 1.0
        addChild(enemyHealthBar)
        addChild(enemyLifeBar)
        
        fabricMasterLabel.text = fabricMaster.theName()
        fabricMasterLabel.zPosition = 0.9
        labelDefaultSettings(fabricMasterLabel)
        fabricMasterLabel.position = CGPoint(x: enemyHealthBar.position.x + 150, y: fabricMaster.position.y  + 178)
        addChild(fabricMasterLabel)
    }
    
    func addSpellBook() {
        spellBookButton = SKSpriteNode(imageNamed: "SpellBookClosed.png")
        spellBookButton.position = CGPoint(x: size.width - 1225, y: size.height - 700)
        spellBookButton.zPosition = 1.5
        spellBookButton.setScale(0.1)
        addChild(spellBookButton)
    }
    
    func addSpellBookOpen() {
        spellBookButton = SKSpriteNode(imageNamed: "SpellBook.png")
        spellBookButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        spellBookButton.zPosition = 1.5
        spellBookButton.setScale(0.8)
        cancelButton = SKSpriteNode(imageNamed: "cancelButton.png")
        cancelButton.position = CGPoint(x: spellBookButton.position.x + 450, y: spellBookButton.position.y + 260)
        cancelButton.zPosition = spellBookButton.zPosition + 0.2
        cancelButton.setScale(0.3)
        forwardArrow = SKSpriteNode(imageNamed: "arrow")
        forwardArrow.position = CGPoint(x: spellBookButton.position.x + 470, y: spellBookButton.position.y)
        forwardArrow.zPosition = spellBookButton.zPosition + 0.2
        forwardArrow.setScale(0.4)
        
        
        physicalLabel.text = "Physical Attacks:"
        physicalLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 200)
        physicalLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.brownColor(),label: physicalLabel)

        physicalSpellOne.text = "Whip"
        physicalSpellOne.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 150)
        physicalSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.brownColor(),label: physicalSpellOne)

        physicalSpellTwo.text = "Constrict"
        physicalSpellTwo.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 100)
        physicalSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.brownColor(),label: physicalSpellTwo)
        
        physicalSpellThree.text = "Thrash"
        physicalSpellThree.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 50)
        physicalSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.brownColor(),label: physicalSpellThree)
        
        aramidLabel.text = "Spell Type: Aramid"
        aramidLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 50)
        aramidLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.yellowColor(),label: aramidLabel)
        
        aramidSpellOne.text = "Aramid Ward"
        aramidSpellOne.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 100)
        aramidSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.yellowColor(),label: aramidSpellOne)
        
        aramidSpellTwo.text = "Aramid Guard"
        aramidSpellTwo.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 150)
        aramidSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.yellowColor(),label: aramidSpellTwo)
        
        aramidSpellThree.text = "Aegis's Last Stand"
        aramidSpellThree.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 200)
        aramidSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.yellowColor(),label: aramidSpellThree)

        cottonLabel.text = "Spell Type: Cotton"
        cottonLabel.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 200)
        cottonLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.redColor(),label: cottonLabel)
        
        cottonSpellOne.text = "Cotton Flare"
        cottonSpellOne.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 150)
        cottonSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.redColor(),label: cottonSpellOne)
        
        cottonSpellTwo.text = "Cotton Blaze"
        cottonSpellTwo.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 100)
        cottonSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.redColor(),label: cottonSpellTwo)
        
        cottonSpellThree.text = "Wildfire"
        cottonSpellThree.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 50)
        cottonSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.redColor(),label: cottonSpellThree)

        silkLabel.text = "Spell Type: Silk"
        silkLabel.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 50)
        silkLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.purpleColor(),label: silkLabel)
        
        silkSpellOne.text = "Silk Trick"
        silkSpellOne.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 100)
        silkSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.purpleColor(),label: silkSpellOne)
        
        silkSpellTwo.text = "Silk Daze"
        silkSpellTwo.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 150)
        silkSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.purpleColor(),label: silkSpellTwo)
        
        silkSpellThree.text = "Pièce de Résistance"
        silkSpellThree.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 200)
        silkSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.purpleColor(),label: silkSpellThree)
        
        addChild(spellBookButton)
        addChild(cancelButton)
        addChild(forwardArrow)
        addChild(physicalLabel)
        addChild(physicalSpellOne)
        addChild(physicalSpellTwo)
        addChild(physicalSpellThree)
        addChild(aramidLabel)
        addChild(aramidSpellOne)
        addChild(aramidSpellTwo)
        addChild(aramidSpellThree)
        addChild(cottonLabel)
        addChild(cottonSpellOne)
        addChild(cottonSpellTwo)
        addChild(cottonSpellThree)
        addChild(silkLabel)
        addChild(silkSpellOne)
        addChild(silkSpellTwo)
        addChild(silkSpellThree)
    }
    
    func addSpellBookOpenPgTwo() {
        spellBookButton = SKSpriteNode(imageNamed: "SpellBook.png")
        spellBookButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        spellBookButton.zPosition = 1.5
        spellBookButton.setScale(0.8)
        cancelButton = SKSpriteNode(imageNamed: "cancelButton.png")
        cancelButton.position = CGPoint(x: spellBookButton.position.x + 450, y: spellBookButton.position.y + 260)
        cancelButton.zPosition = spellBookButton.zPosition + 0.2
        cancelButton.setScale(0.3)
        backArrow = SKSpriteNode(imageNamed: "arrowReverse.png")
        backArrow.position = CGPoint(x: spellBookButton.position.x - 470, y: spellBookButton.position.y)
        backArrow.zPosition = spellBookButton.zPosition + 0.2
        backArrow.setScale(0.4)
        
        rayonLabel.text = "Spell Type: Rayon"
        rayonLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 200)
        rayonLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.blueColor(),label: rayonLabel)
        
        rayonSpellOne.text = "Rayon Strike"
        rayonSpellOne.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 150)
        rayonSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.blueColor(),label: rayonSpellOne)
        
        rayonSpellTwo.text = "Rayon Bash"
        rayonSpellTwo.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 100)
        rayonSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.blueColor(),label: rayonSpellTwo)
        
        rayonSpellThree.text = "Kusanagi no Tsurugi"
        rayonSpellThree.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 50)
        rayonSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.blueColor(),label: rayonSpellThree)
        
        
        addChild(spellBookButton)
        addChild(cancelButton)
        addChild(backArrow)
        addChild(rayonLabel)
        addChild(rayonSpellOne)
        addChild(rayonSpellTwo)
        addChild(rayonSpellThree)
    }
    
    func addPlayerHealthBarLabel() {
        mainCharacterLife = CGFloat((Float(mc.currentHp) / Float(mc.maxHP)))
        mainCharacterHealthBar = SKSpriteNode(imageNamed: "healthBar2.png")
        mainCharacterHealthBar.position = CGPoint(x: frame.width - 350, y: frame.height - 650)
        mainCharacterHealthBar.setScale(1.0)
        mainCharacterHealthBar.zPosition = 0.4
        mainCharacterLifeBar = SKSpriteNode(imageNamed: "health2.png")
        mainCharacterLifeBar.position = CGPoint(x: mainCharacterHealthBar.position.x + 160, y: mainCharacterHealthBar.position.y - 11)
        mainCharacterLifeBar.xScale = mainCharacterLife
        mainCharacterLifeBar.yScale = 1.0
        mainCharacterLifeBar.zPosition = 0.5
        mainCharacterLifeBar.anchorPoint = CGPointMake(1.0, 0.5)
        
        mcHpLabel.text = mc.hP()
        mcName.text = mc.theName()
        mcHpLabel.zPosition = 0.7
        mcName.zPosition = 0.7
        labelDefaultSettingsHp(mcHpLabel)
        labelDefaultSettings(mcName)
        mcHpLabel.position = CGPoint(x: mainCharacterHealthBar.position.x + 20, y: mainCharacterHealthBar.position.y + 22)
        mcName.position = CGPoint(x: mainCharacterHealthBar.position.x - 170, y: mainCharacterHealthBar.position.y + 22)
        mcLevelLabel.text = "Lv. 99";
        mcLevelLabel.zPosition = 0.7
        labelDefaultSettingsLv(mcLevelLabel)
        mcLevelLabel.position = CGPoint(x: mainCharacterHealthBar.position.x - 80, y: mainCharacterHealthBar.position.y + 22)
        
        addChild(mcHpLabel)
        addChild(mcName)
        addChild(mcLevelLabel)
        
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
        mcHpLabel.hidden = isHidden
        mcLevelLabel.hidden = isHidden
        mcName.hidden = isHidden
        spellBookButton.hidden = isHidden
        
    }

    func removeAllObjects() {
        forwardArrow.removeFromParent()
        backArrow.removeFromParent()
        physicalLabel.removeFromParent()
        physicalSpellOne.removeFromParent()
        physicalSpellTwo.removeFromParent()
        physicalSpellThree.removeFromParent()
        cottonLabel.removeFromParent()
        cottonSpellOne.removeFromParent()
        cottonSpellTwo.removeFromParent()
        cottonSpellThree.removeFromParent()
        rayonLabel.removeFromParent()
        rayonSpellOne.removeFromParent()
        rayonSpellTwo.removeFromParent()
        rayonSpellThree.removeFromParent()
        silkLabel.removeFromParent()
        silkSpellOne.removeFromParent()
        silkSpellTwo.removeFromParent()
        silkSpellThree.removeFromParent()
        aramidLabel.removeFromParent()
        aramidSpellOne.removeFromParent()
        aramidSpellTwo.removeFromParent()
        aramidSpellThree.removeFromParent()
        spellBookButton.removeFromParent()
        cancelButton.removeFromParent()
    }
    
    func pauseGame() {
        scene!.view!.paused = true
    }
    
    func labelDefaultSettings(label: SKLabelNode){
        label.fontColor = SKColor.whiteColor()
        label.fontSize = 35.0
        label.fontName = "AvenirNext-Bold"
    }
    
    func labelDefaultSettingsHp(label: SKLabelNode){
        label.fontColor = SKColor.whiteColor()
        label.fontSize = 25.0
        label.fontName = "AvenirNext-Bold"
    }
    func labelDefaultSettingsLv(label: SKLabelNode){
        label.fontColor = SKColor.whiteColor()
        label.fontSize = 15.0
        label.fontName = "AvenirNext-Bold"
    }
    
    func labelDefaultSettingsSpellNames(color: SKColor,label: SKLabelNode){
        label.fontColor = color
        label.fontSize = 35.0
        label.fontName = "AvenirNext-Bold"
    }
    
    func labelDefaultSettingsSpellList(color: SKColor,label: SKLabelNode){
        label.fontColor = color
        label.fontSize = 30.0
        label.fontName = "AvenirNext-Bold"
    }
    
    override func update(currentTime: CFTimeInterval) {
        mcHpLabel.text = mc.hP()
        
        mainCharacterLife = CGFloat(Float(mc.currentHp) / Float(mc.maxHP))
        self.enemyLife = CGFloat(Float(self.fabricMaster.currentHp) / Float(self.fabricMaster.maxHP))
        
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
            let waitAttack = SKAction.waitForDuration(3.0)
            fabricMaster.runAction(waitAttack) { () -> Void in
            skill.animateAction(self, caster: self.fabricMaster, target: self.mc, completion: { () -> Void in
                self.fabricMaster.attack(self.mc, skillName: "spiderWeb")
            })
         }
        }
    }
    
    func evaluateGameOver(){
        var scene: GameOverScene!
        if mc.currentHp <= 0 {
            scene = GameOverScene(size: size, won: false)
            scene.nextLevel = level
        }else if(fabricMaster.currentHp <= 0){
            scene = GameOverScene(size: size, won: true)
            scene.nextLevel = (level + 1) % MonsterOrder.order.count
          
        }else{
            return
        }
        scene.scaleMode = scaleMode
        scene.mc = mc
        mc.removeFromParent()
        SKTAudio.sharedInstance().fadeVolumeAndPause()
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(scene, transition: reveal)
    }
    
    
}
