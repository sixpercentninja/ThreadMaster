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
    var mc = Player()
    var mcHpLabel = SKLabelNode()
    var mcName = SKLabelNode()
    var mcLevelLabel = SKLabelNode()
    var mainCharacterHealthBar = SKSpriteNode()
    var mainCharacterLifeBar = SKSpriteNode()
    var mainCharacterLife = CGFloat()
    var enemyHealthBar = SKSpriteNode()
    var enemyLifeBar = SKSpriteNode()
    var enemyLife = CGFloat()
    
    var getDamaged = SKLabelNode()
    
    var rawPoints:[Int] = []
    var recognizer: DBPathRecognizer?
    
    var yourline: SKShapeNode = SKShapeNode()
    
    var level = 0
    
    var spellBookButton = SKSpriteNode()
    var cancelButton = SKSpriteNode()
    var forwardArrow = SKSpriteNode()
    var backArrow = SKSpriteNode()
    var skillNameLabel = SKLabelNode()
    var skillDamageLabel = SKLabelNode()
    var skillAttributeLabel = SKLabelNode()
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

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//          Pause game
//        self.runAction(SKAction.runBlock(self.pauseGame))

        
        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0, costMax: 5)
        
        self.recognizer = recognizer
        
        addBG("bg1")
        addPlayer()
        addEnemy(level)
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
                    self.spellBookButton.removeFromParent()
                    self.addSpellBookOpen()
                    self.forwardArrow.name = "to pg 2"
                    self.forwardArrow.userInteractionEnabled = false
                    self.addAllNodeNames()
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
            else if name == "to pg 2" {
                removeAllObjects()
                addSpellBookOpenPgTwo()
                backArrow.name = "back to pg 1"
                backArrow.userInteractionEnabled = false
                cancelButton.name = "cancelButton"
                cancelButton.userInteractionEnabled = false
                forwardArrow.name = "to pg 3"
                forwardArrow.userInteractionEnabled = false
            }
            else if name == "to pg 3" {
                removeAllObjects()
                addSpellBookOpenPgThree()
                backArrow.name = "back to pg 2"
                backArrow.userInteractionEnabled = false
                cancelButton.name = "cancelButton"
                cancelButton.userInteractionEnabled = false
            }
            
            else if name == "back to pg 1" {
                removeAllObjects()
                addSpellBookOpen()
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
                self.forwardArrow.name = "to pg 2"
                self.forwardArrow.userInteractionEnabled = false
            }
            else if name == "back to pg 2" {
                removeAllObjects()
                addSpellBookOpenPgTwo()
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
                self.backArrow.name = "back to pg 1"
                self.backArrow.userInteractionEnabled = false
                self.forwardArrow.name = "to pg 3"
                self.forwardArrow.userInteractionEnabled = false
            }
            
            else if name == "whip" {
                print("Hi!")
            }
             
            else if name == "Aramid Ward" {
                removeAllObjects()
                addSpellBookDetail(AramidWard())
                self.backArrow.name = "back to pg 1"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
                
            else if name == "Aramid Guard" {
                removeAllObjects()
                addSpellBookDetail(AramidGuard())
                self.backArrow.name = "back to pg 1"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
                
            else if name == "Aegis' Last Stand" {
                removeAllObjects()
                addSpellBookDetail(AegisLastStand())
                self.backArrow.name = "back to pg 1"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
                
            else if name == "Cotton Blaze" {
                removeAllObjects()
                addSpellBookDetail(CottonBlaze())
                self.backArrow.name = "back to pg 2"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
                
            else if name == "Cotton Flare" {
                removeAllObjects()
                addSpellBookDetail(CottonFlare())
                self.backArrow.name = "back to pg 2"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
            
            else if name == "Wildfire" {
                removeAllObjects()
                addSpellBookDetail(WildFire())
                self.backArrow.name = "back to pg 2"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
            
            else if name == "Silk Trick" {
                removeAllObjects()
                addSpellBookDetail(SilkTrick())
                self.backArrow.name = "back to pg 2"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
                
            else if name == "Silk Daze" {
                removeAllObjects()
                addSpellBookDetail(SilkDaze())
                self.backArrow.name = "back to pg 2"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
                
            else if name == "Piece De Resistance" {
                removeAllObjects()
                addSpellBookDetail(PieceDeResistance())
                self.backArrow.name = "back to pg 2"
                self.backArrow.userInteractionEnabled = false
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
            }
                
            else if name == "Rayon Strike" {
                removeAllObjects()
                addSpellBookDetail(RayonStrike())
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
                self.backArrow.name = "to pg 3"
                self.backArrow.userInteractionEnabled = false
            }
                
            else if name == "Rayon Bash" {
                removeAllObjects()
                addSpellBookDetail(RayonBash())
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
                self.backArrow.name = "to pg 3"
                self.backArrow.userInteractionEnabled = false
            }
                
            else if name == "Kusanagi No Tsurugi" {
                removeAllObjects()
                addSpellBookDetail(KusanagiNoTsurugi())
                self.cancelButton.name = "cancelButton"
                self.cancelButton.userInteractionEnabled = false
                self.backArrow.name = "to pg 3"
                self.backArrow.userInteractionEnabled = false
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
                    let bounceHigh = SKAction.moveTo(CGPoint(x: self.fabricMaster.position.x, y: self.fabricMaster.position.y + 30), duration: 0.3)
                    let bounceDown = SKAction.moveTo(CGPoint(x: self.fabricMaster.position.x, y: self.fabricMaster.position.y - 30), duration: 0.6)
                    let bounceHighLite = SKAction.moveTo(CGPoint(x: self.fabricMaster.position.x, y: self.fabricMaster.position.y - 10), duration: 0.2)
                    let bounceDownLite = SKAction.moveTo(CGPoint(x: self.fabricMaster.position.x, y: self.fabricMaster.position.y - 40), duration: 0.3)
                    let waitDuration = SKAction.waitForDuration(1.0)
                    let sequence = SKAction.sequence([bounceHigh, bounceDown, bounceHighLite, bounceDownLite, waitDuration])

                    self.getDamaged.text = "\(skill.damage)"
                    self.getDamaged.zPosition = 1.1
                    self.getDamaged.position = CGPoint(x: self.fabricMaster.position.x, y: self.fabricMaster.position.y)
                    self.labelDefaultSettingsDamage(45.0, label: self.getDamaged)
                    self.addChild(self.getDamaged)
                    
                    self.getDamaged.runAction(sequence) { () -> Void in
                        self.getDamaged.removeFromParent()
                        self.evaluateGameOver()
                        self.enemyRetaliation()
                        self.evaluateGameOver()
                    }

                    
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
        physicalLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 230)
        physicalLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.brownColor(),label: physicalLabel)

        physicalSpellOne.text = "Whip"
        physicalSpellOne.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 90)
        physicalSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.brownColor(),label: physicalSpellOne)

        physicalSpellTwo.text = "Constrict"
        physicalSpellTwo.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 50)
        physicalSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.brownColor(),label: physicalSpellTwo)
        
        physicalSpellThree.text = "Thrash"
        physicalSpellThree.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 190)
        physicalSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.brownColor(),label: physicalSpellThree)
        
        aramidLabel.text = "Spell Type: Aramid"
        aramidLabel.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 230)
        aramidLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.yellowColor(),label: aramidLabel)
        
        aramidSpellOne.text = "Aramid Ward"
        aramidSpellOne.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 90)
        aramidSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.yellowColor(),label: aramidSpellOne)
        
        aramidSpellTwo.text = "Aramid Guard"
        aramidSpellTwo.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 50)
        aramidSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.yellowColor(),label: aramidSpellTwo)
        
        aramidSpellThree.text = "Aegis's Last Stand"
        aramidSpellThree.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 190)
        aramidSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.yellowColor(),label: aramidSpellThree)

        
        
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
        forwardArrow = SKSpriteNode(imageNamed: "arrow")
        forwardArrow.position = CGPoint(x: spellBookButton.position.x + 470, y: spellBookButton.position.y)
        forwardArrow.zPosition = spellBookButton.zPosition + 0.2
        forwardArrow.setScale(0.4)
        
        cottonLabel.text = "Spell Type: Cotton"
        cottonLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 230)
        cottonLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.redColor(),label: cottonLabel)
        
        cottonSpellOne.text = "Cotton Flare"
        cottonSpellOne.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 90)
        cottonSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.redColor(),label: cottonSpellOne)
        
        cottonSpellTwo.text = "Cotton Blaze"
        cottonSpellTwo.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 50)
        cottonSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.redColor(),label: cottonSpellTwo)
        
        cottonSpellThree.text = "Wildfire"
        cottonSpellThree.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 190)
        cottonSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.redColor(),label: cottonSpellThree)
        
        silkLabel.text = "Spell Type: Silk"
        silkLabel.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 230)
        silkLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.purpleColor(),label: silkLabel)
        
        silkSpellOne.text = "Silk Trick"
        silkSpellOne.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y + 90)
        silkSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.purpleColor(),label: silkSpellOne)
        
        silkSpellTwo.text = "Silk Daze"
        silkSpellTwo.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 50)
        silkSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.purpleColor(),label: silkSpellTwo)
        
        silkSpellThree.text = "Pièce de Résistance"
        silkSpellThree.position = CGPoint(x: spellBookButton.position.x + 225, y: spellBookButton.position.y - 190)
        silkSpellThree.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.purpleColor(),label: silkSpellThree)
        
        addChild(spellBookButton)
        addChild(cancelButton)
        addChild(forwardArrow)
        addChild(backArrow)
        addChild(cottonLabel)
        addChild(cottonSpellOne)
        addChild(cottonSpellTwo)
        addChild(cottonSpellThree)
        addChild(silkLabel)
        addChild(silkSpellOne)
        addChild(silkSpellTwo)
        addChild(silkSpellThree)
    }
    
    func addSpellBookOpenPgThree() {
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
        rayonLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 230)
        rayonLabel.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellNames(SKColor.blueColor(),label: rayonLabel)
        
        rayonSpellOne.text = "Rayon Strike"
        rayonSpellOne.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 90)
        rayonSpellOne.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.blueColor(),label: rayonSpellOne)
        
        rayonSpellTwo.text = "Rayon Bash"
        rayonSpellTwo.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 50)
        rayonSpellTwo.zPosition = spellBookButton.zPosition + 0.1
        labelDefaultSettingsSpellList(SKColor.blueColor(),label: rayonSpellTwo)
        
        rayonSpellThree.text = "Kusanagi no Tsurugi"
        rayonSpellThree.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 190)
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
    
    func addSpellBookDetail(spellClass: Skill) {
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
        
        skillNameLabel.text = spellClass.skillName
        skillNameLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y + 200)
        skillNameLabel.zPosition = spellBookButton.zPosition + 0.1
        
        skillDamageLabel.text = String("Base Damage: \(spellClass.damage)")
        skillDamageLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y)
        skillDamageLabel.zPosition = spellBookButton.zPosition + 0.1
        
        skillAttributeLabel.text = String("Attribute: \(spellClass.attackAttribute)")
        skillAttributeLabel.position = CGPoint(x: spellBookButton.position.x - 225, y: spellBookButton.position.y - 100)
        skillAttributeLabel.zPosition = spellBookButton.zPosition + 0.1

        
        if spellClass.skillName == "Whip" || spellClass.skillName == "Constrict" || spellClass.skillName == "Thrash" {
            labelDefaultSettingsResizer(50.0, color: SKColor.brownColor(), label: skillNameLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.brownColor(), label: skillDamageLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.brownColor(), label: skillAttributeLabel)

        } else if spellClass.skillName == "Aramid Ward" || spellClass.skillName == "Aramid Guard" || spellClass.skillName == "Aegis' Last Stand" {
            labelDefaultSettingsResizer(50.0, color: SKColor.yellowColor(), label: skillNameLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.yellowColor(), label: skillDamageLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.yellowColor(), label: skillAttributeLabel)
            
        } else if spellClass.skillName == "Cotton Flare" || spellClass.skillName == "Cotton Blaze" || spellClass.skillName == "Wildfire" {
            labelDefaultSettingsResizer(50.0, color: SKColor.redColor(), label: skillNameLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.redColor(), label: skillDamageLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.redColor(), label: skillAttributeLabel)
            
        } else if spellClass.skillName == "Silk Trick" || spellClass.skillName == "Silk Daze" || spellClass.skillName == "Pièce de Résistance" {
            labelDefaultSettingsResizer(50.0, color: SKColor.purpleColor(), label: skillNameLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.purpleColor(), label: skillDamageLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.purpleColor(), label: skillAttributeLabel)
            
        } else if spellClass.skillName == "Rayon Strike" || spellClass.skillName == "Rayon Bash" || spellClass.skillName == "Kusanagi No Tsurugi" {
            labelDefaultSettingsResizer(50.0, color: SKColor.blueColor(), label: skillNameLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.blueColor(), label: skillDamageLabel)
            labelDefaultSettingsResizer(40.0, color: SKColor.blueColor(), label: skillAttributeLabel)
            
        }

        
        addChild(spellBookButton)
        addChild(cancelButton)
        addChild(backArrow)
        addChild(skillNameLabel)
        addChild(skillDamageLabel)
        addChild(skillAttributeLabel)

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

    func addAllNodeNames() {
        self.cancelButton.name = "cancelButton"
        self.cancelButton.userInteractionEnabled = false
        self.physicalSpellOne.name = "Whip"
        self.physicalSpellOne.userInteractionEnabled = false
        self.physicalSpellTwo.name = "Constrict"
        self.physicalSpellTwo.userInteractionEnabled = false
        self.physicalSpellThree.name = "Thrash"
        self.physicalSpellThree.userInteractionEnabled = false
        self.aramidSpellOne.name = "Aramid Ward"
        self.aramidSpellOne.userInteractionEnabled = false
        self.aramidSpellTwo.name = "Aramid Guard"
        self.aramidSpellTwo.userInteractionEnabled = false
        self.aramidSpellThree.name = "Aegis' Last Stand"
        self.aramidSpellThree.userInteractionEnabled = false
        self.cottonSpellOne.name = "Cotton Flare"
        self.cottonSpellOne.userInteractionEnabled = false
        self.cottonSpellTwo.name = "Cotton Blaze"
        self.cottonSpellTwo.userInteractionEnabled = false
        self.cottonSpellThree.name = "Wildfire"
        self.cottonSpellThree.userInteractionEnabled = false
        self.silkSpellOne.name = "Silk Trick"
        self.silkSpellOne.userInteractionEnabled = false
        self.silkSpellTwo.name = "Silk Daze"
        self.silkSpellTwo.userInteractionEnabled = false
        self.silkSpellThree.name = "Piece De Resistance"
        self.silkSpellThree.userInteractionEnabled = false
        self.rayonSpellOne.name = "Rayon Strike"
        self.rayonSpellOne.userInteractionEnabled = false
        self.rayonSpellTwo.name = "Rayon Bash"
        self.rayonSpellTwo.userInteractionEnabled = false
        self.rayonSpellThree.name = "Kusanagi No Tsurugi"
        self.rayonSpellThree.userInteractionEnabled = false
    }
    
    func removeAllObjects() {
        forwardArrow.removeFromParent()
        backArrow.removeFromParent()
        skillNameLabel.removeFromParent()
        skillDamageLabel.removeFromParent()
        skillAttributeLabel.removeFromParent()
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
        label.fontSize = 45.0
        label.fontName = "Papyrus"
    }
    
    func labelDefaultSettingsSpellList(color: SKColor,label: SKLabelNode){
        label.fontColor = color
        label.fontSize = 40.0
        label.fontName = "Papyrus"
    }
    
    func labelDefaultSettingsResizer(fontSize: CGFloat, color: SKColor,label: SKLabelNode){
        label.fontColor = color
        label.fontSize = fontSize
        label.fontName = "Papyrus"
    }
    
    func labelDefaultSettingsDamage(fontSize: CGFloat, label: SKLabelNode){
        label.fontColor = SKColor.redColor()
        label.fontSize = fontSize
        label.fontName = "Optima-ExtraBlack"
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
            let waitAttack = SKAction.waitForDuration(1.5)
            fabricMaster.runAction(waitAttack) { () -> Void in
            skill.animateAction(self, caster: self.fabricMaster, target: self.mc, completion: { () -> Void in
                self.fabricMaster.attack(self.mc, skillName: "spiderWeb")
                let bounceHigh = SKAction.moveTo(CGPoint(x: self.mc.position.x, y: self.mc.position.y + 30), duration: 0.3)
                let bounceDown = SKAction.moveTo(CGPoint(x: self.mc.position.x, y: self.mc.position.y - 30), duration: 0.6)
                let bounceHighLite = SKAction.moveTo(CGPoint(x: self.mc.position.x, y: self.mc.position.y - 10), duration: 0.2)
                let bounceDownLite = SKAction.moveTo(CGPoint(x: self.mc.position.x, y: self.mc.position.y - 40), duration: 0.3)
                let waitDuration = SKAction.waitForDuration(1.0)
                let sequence = SKAction.sequence([bounceHigh, bounceDown, bounceHighLite, bounceDownLite, waitDuration])
                
                self.getDamaged.text = "\(skill.damage)"
                self.getDamaged.zPosition = 1.1
                self.getDamaged.position = CGPoint(x: self.mc.position.x, y: self.mc.position.y)
                self.labelDefaultSettingsDamage(55.0, label: self.getDamaged)
                self.addChild(self.getDamaged)
                
                self.getDamaged.runAction(sequence) { () -> Void in
                    self.getDamaged.removeFromParent()
                }

            })
         }
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
