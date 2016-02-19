//
//  GameScene.swift
//  ThreadMagic
//
//  Created by Andrew Chen on 2/16/16.
//  Copyright (c) 2016 Andrew Chen. All rights reserved.
//


import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let textureAtlas = SKTextureAtlas(named: "fabricMaster1")
    var fabricMasterArray = Array<SKTexture>()
    var fabricMaster = SKSpriteNode()
    var shake = Array<CGPoint>()
    
    let textureAt = SKTextureAtlas(named: "mc")
    var mcArray = Array<SKTexture>()
    var mc = SKSpriteNode()

    
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
        
        addBG()
        addPlayer()
        addMonster()
        
        
        yourline.strokeColor = SKColor.redColor()
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
            }
            print(letter)
        } else {
//            letter.text = "-"
        }
    }
    
    
    
    func addBG() {
        let bg = SKSpriteNode(imageNamed: "bg")
        bg.zPosition = -1
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(bg)
        print("Size: \(bg.size)")
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        /* Called when touched */
//        waterAnimation()
//        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            
//        }
//    }
    
    func addPlayer() {
        mcArray.append(textureAt.textureNamed("1"))
        mcArray.append(textureAt.textureNamed("2"))
        mcArray.append(textureAt.textureNamed("3"))
        mcArray.append(textureAt.textureNamed("4"))
        
        mc = SKSpriteNode(texture: mcArray[0])
        mc.position = CGPoint(x: 350, y: 320)
        mc.xScale = 1.2
        mc.yScale = 1.2
        addChild(mc)
        
        let animateAction = SKAction.animateWithTextures(mcArray, timePerFrame: 0.30)
        let repeatAction = SKAction.repeatActionForever(animateAction)
        mc.runAction(repeatAction)
    }
    
    func addMonster() {
        fabricMasterArray.append(textureAtlas.textureNamed("1"))
        fabricMasterArray.append(textureAtlas.textureNamed("2"))
        fabricMaster = SKSpriteNode(texture:fabricMasterArray[0])
        fabricMaster.position = CGPoint(x: 940, y: 520)
        fabricMaster.xScale = 1.0
        fabricMaster.yScale = 1.0
        addChild(fabricMaster)
        
        let animateAction = SKAction.animateWithTextures(fabricMasterArray, timePerFrame: 0.30)
        let repeatAction = SKAction.repeatActionForever(animateAction)
        fabricMaster.runAction(repeatAction)
        
        fabricMaster.physicsBody = SKPhysicsBody(rectangleOfSize: fabricMaster.size)
        fabricMaster.physicsBody?.dynamic = true
        //        fabricMaster.physicsBody?.categoryBitMask
        //        fabricMaster.physicsBody?
        //        fabricMaster
        
    }
    
    func waterAnimation() {
        let textAtlas = SKTextureAtlas(named: "water")
        var waterArray = Array<SKTexture>()
        var waterSpell = SKSpriteNode()
        
        waterArray.append(textAtlas.textureNamed("1"))
        waterArray.append(textAtlas.textureNamed("2"))
        waterArray.append(textAtlas.textureNamed("3"))
        waterArray.append(textAtlas.textureNamed("4"))
        waterArray.append(textAtlas.textureNamed("5"))
        waterArray.append(textAtlas.textureNamed("6"))
        waterArray.append(textAtlas.textureNamed("7"))
        waterArray.append(textAtlas.textureNamed("8"))
        waterArray.append(textAtlas.textureNamed("9"))
        
        waterSpell = SKSpriteNode(texture: waterArray[0])
        waterSpell.zPosition = 0.6
        waterSpell.position = CGPoint(x: 870, y: 670)
        waterSpell.setScale(1.2)
        addChild(waterSpell)
        
        let animate = SKAction.animateWithTextures(waterArray, timePerFrame: 0.15)
        waterSpell.runAction(animate) { () -> Void in
            waterSpell.removeFromParent()
            let colorize = SKAction.colorizeWithColor(.blueColor(), colorBlendFactor: 1, duration: 0.5)
            self.fabricMaster.runAction(colorize) { () -> Void in
                self.fabricMaster.removeFromParent()
                self.addMonster()
                let rotateLeft = SKAction.rotateToAngle(0.3, duration: 0.1)
                let rotateRight = SKAction.rotateToAngle(-0.3, duration: 0.1)
                let rotateNormal = SKAction.rotateToAngle(0, duration: 0.1)
                let actionSequence = SKAction.sequence([rotateLeft, rotateRight, rotateLeft, rotateRight, rotateLeft, rotateNormal])
                self.fabricMaster.runAction(actionSequence)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}
