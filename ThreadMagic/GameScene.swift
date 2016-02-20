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
    var fabricMasterLabel = SKLabelNode()
    var mc = Player()
    var mcLabel = SKLabelNode()
    
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

            if(letter == "C"){
                waterAnimation()
                mc.attack(fabricMaster, skillName: "wetTowelSlap")
                fabricMasterLabel.text = "\(fabricMaster.charName): \(fabricMaster.currentHp)/ \(fabricMaster.maxHP)"
                mcLabel.text = "\(mc.charName): \(mc.currentHp)/ \(mc.maxHP)"
            }
            print(letter)
        } else {
//            letter.text = "-"
        }
        
        if fabricMaster.currentHp <= 0 {
            defeated(fabricMaster)
            //Win transistion here
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
        let textureAtlas = SKTextureAtlas(named: "mc")
        
        let mcArray = textureAtlas.textureNames.map({ textureAtlas.textureNamed($0) })
        
        mc = Player(imageNamed: textureAtlas.textureNames.first!, maxHP: 50, charName: "Steven", attribute: Attribute.Neutral)

        mc.position = CGPoint(x: 350, y: 320)
        mc.xScale = 1.2
        mc.yScale = 1.2
        
        addChild(mc)
        
        let animateAction = SKAction.animateWithTextures(mcArray, timePerFrame: 0.30)
        let repeatAction = SKAction.repeatActionForever(animateAction)
        mc.runAction(repeatAction)
        
        mcLabel.text = "\(mc.charName): \(mc.currentHp)/ \(mc.maxHP)"
        labelDefaultSettings(mcLabel)
        mcLabel.position = CGPoint(x: size.width - (mcLabel.frame.width/2) - 10, y: 0 + (mcLabel.frame.height) + 10)
        addChild(mcLabel)
    }
    
    func addMonster(atlasName: String) {
        let textureAtlas = SKTextureAtlas(named: atlasName)
        fabricMaster.textureAtlas = textureAtlas
        
        let fabricMasterArray = textureAtlas.textureNames.map({ textureAtlas.textureNamed($0) })
        
        fabricMaster = Monster(imageNamed: textureAtlas.textureNames.first!, maxHP: 100, charName: "Cuadsf", attribute: Attribute.Heat)
        fabricMaster.position = CGPoint(x: 940, y: 520)
        
        addChild(fabricMaster)
        
        let animateAction = SKAction.animateWithTextures(fabricMasterArray, timePerFrame: 0.30)
        let repeatAction = SKAction.repeatActionForever(animateAction)
        
        fabricMaster.runAction(repeatAction)
        
        fabricMasterLabel.text = "\(fabricMaster.charName): \(fabricMaster.currentHp)/ \(fabricMaster.maxHP)"
        labelDefaultSettings(fabricMasterLabel)
        fabricMasterLabel.position = CGPoint(x: 0 + (fabricMasterLabel.frame.width/2) + 10, y: size.height - (fabricMasterLabel.frame.height) - 50)
        addChild(fabricMasterLabel)
    }
    
    func waterAnimation() {
        let textAtlas = SKTextureAtlas(named: "water")
        var waterSpell = SKSpriteNode()
        
        let waterArray = textAtlas.textureNames.sort().map({ textAtlas.textureNamed($0) })
        
        waterSpell = SKSpriteNode(texture: waterArray[0])
        waterSpell.zPosition = 0.6
        waterSpell.position = CGPoint(x: 870, y: 670)
        waterSpell.setScale(1.2)
        addChild(waterSpell)
        
        let animate = SKAction.animateWithTextures(waterArray, timePerFrame: 0.15)
        waterSpell.runAction(animate) { () -> Void in
            waterSpell.removeFromParent()
            let colorize = SKAction.colorizeWithColor(.blueColor(), colorBlendFactor: 1, duration: 0.5)
            let rotateLeft = SKAction.rotateToAngle(0.3, duration: 0.1)
            let rotateRight = SKAction.rotateToAngle(-0.3, duration: 0.1)
            let rotateNormal = SKAction.rotateToAngle(0, duration: 0.1)
            let actionSequence = SKAction.sequence([colorize, rotateLeft, rotateRight, rotateLeft, rotateRight, rotateLeft, rotateNormal, colorize.reversedAction()])
            self.fabricMaster.runAction(actionSequence)
        }
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
    
    }
    
    
}
