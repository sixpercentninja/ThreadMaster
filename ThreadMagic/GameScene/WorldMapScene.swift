//
//  WorldMapScene.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 29/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit

class WorldMapScene: SKScene, tileMapDelegate, SKPhysicsContactDelegate, PlayerEntityDelegate {
    
    var mcLevelLabel = SKLabelNode()

    var worldGen = tileMap()
    //Layers
    var worldLayer = SKNode()
    var guiLayer = SKNode()
    var enemyLayer = SKNode()
    var overlayLayer = SKNode()
    var entities = Set<GKEntity>()
    
    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0
    var lastDeltaTime: NSTimeInterval = 0
    
    let playerEntity = PlayerEntity()
    
    var mapLevel: MapLevel!
    var firstLoad = true
    
    var tiles: [String: SKTexture]!
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass:
        AnimationComponent.self)
        let playerMoveSystem = GKComponentSystem(componentClass:
        PlayerMoveComponent.self)
        return [animationSystem, playerMoveSystem]
    }()
    
    init(size: CGSize, mapLevel: MapLevel) {
        
        super.init(size: size)
        self.mapLevel = mapLevel
        //Delegates
        worldGen.delegate = self
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        playerEntity.delegate = self
        
        //Setup Camera
        let myCamera = SKCameraNode()
        camera = myCamera
        addChild(myCamera)
        
        
        //Config World
        addChild(worldLayer)
        camera!.addChild(guiLayer)
        guiLayer.addChild(overlayLayer)
        worldLayer.addChild(enemyLayer)
        worldLayer.name = "worldLayer"
    
        let atlasTiles = SKTextureAtlas(named: "Tiles")
        tiles = [:]
        for name in atlasTiles.textureNames{
            let parsedName = name.stringByReplacingOccurrencesOfString(".png", withString: "")
            tiles[parsedName] = atlasTiles.textureNamed(parsedName)
        }
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToView(view: SKView) {

        SKTAudio.sharedInstance().playBackgroundMusic("Home Castle Theme.mp3")
        updateCameraScale()

        if(firstLoad){
            firstLoad = false
            setupLevel()
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        var deltaTime = currentTime - lastUpdateTimeInterval
        deltaTime = deltaTime > maximumUpdateDeltaTime ?
        maximumUpdateDeltaTime : deltaTime
        lastUpdateTimeInterval = currentTime
        
        mcLevelLabel.text = "Kumo, Level: \(Player.mainPlayer.level)"
        //Update all components
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
        
        centerCameraOnPoint(playerEntity.spriteComponent.node.position)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        sceneTouched(location)
//        centerCameraOnPoint(location)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        sceneTouched(location)
    }
    
    // Move player
    func movePlayerToward(location: CGPoint) {
        let offset = location - playerEntity.spriteComponent.node.position
        let direction = offset.normalized()
        playerEntity.moveComponent.movement = direction * playerSettings.movementSpeed
    }
    
    func sceneTouched(touchLocation: CGPoint){
        movePlayerToward(touchLocation)
        playerEntity.moveComponent.lastTouchLocation = touchLocation
    }

    
    func setupLevel() {
        worldGen.generateLevel(100)
//        createBackground()
        worldGen.generateMap(mapLevel)
        worldGen.presentLayerViaDelegate()
        
        worldLayer.enumerateChildNodesWithName("*") {
            node, stop in
            if (node is SKSpriteNode) {
                switch node.name!{
                case "tree0", "tree1":
                    node.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:
                        CGPoint(x: -16, y: -32), size: CGSize(width: 32, height: 32)))
                    node.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
                case "cliffbottom1", "clifftop1":
                    node.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:
                    CGPoint(x: -16, y: -16), size: CGSize(width: 32, height: 32)))
                    node.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
                default:
                    break
                }
            }
        }
    }
    
    func createBackground() {
        worldGen.createGrassLayers()
        let texture = scene!.view?.textureFromNode(worldLayer)
        let node = SKSpriteNode(texture: texture)
        
        worldLayer.removeAllChildren()
        worldLayer.addChild(node)
    }
    
    func createGrassNode(type type: tileType, location: CGPoint) {
        switch type {
        default:
            loadAndDisplaySingleTile(type, location: location)
            break
        }
    }
    
    func createNodeOf(type type: tileType, location: CGPoint) {
        switch type {
//        case .tileGrass:
//            break
        case .tree0, .tree1, .tree2, .tree3, .tree4, .tree5, .tree0empty, .tree1empty:
            loadAndDisplayDoubleTile(type, location: location)
        case .tileStart:
            loadAndDisplaySingleTile(type, location: location)
            
            let playerNode = playerEntity.spriteComponent.node
            playerNode.position = location
            playerNode.name = "playerNode"
            playerNode.zPosition = 2
            playerNode.anchorPoint = CGPointMake(0.5, 0.2)
            
            mcLevelLabel.text = "Kumo, Level: \(Player.mainPlayer.level)"
            mcLevelLabel.zPosition = 2.0
            mcLevelLabel.position = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 20)
            labelDefaultSettings(mcLevelLabel)
            playerNode.addChild(mcLevelLabel)
            
            playerEntity.animationComponent.requestedAnimationState = .Walk_Down
            addEntityToEnemyLayer(playerEntity)
        case .tileEnd:
            
            loadAndDisplaySingleTile(type, location: location)
            let bossEntity = BossEntity(imageNamed: mapLevel.bossImage)
            let enemyNode = bossEntity.spriteComponent.node
            enemyNode.position = location
            enemyNode.name = "enemyNode"
            enemyNode.zPosition = 2
            enemyNode.anchorPoint = CGPointMake(0.5, 0.2)
            addEntityToEnemyLayer(bossEntity)
        default:
            loadAndDisplaySingleTile(type, location: location)
            break
        }
    }
    
    func loadAndDisplaySingleTile(type: tileType, location: CGPoint){
        
        let node = SKSpriteNode(texture: tiles[type.description])
        node.size = CGSize(width: 32, height: 32)
        node.position = location
        node.zPosition = 1
        node.name = type.description
//        node.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:
//            CGPoint(x: -16, y: -16), size: CGSize(width: 32, height: 32)))
//        node.physicsBody?.categoryBitMask = type.categoryBitMask
        worldLayer.addChild(node)
    }
    
    func loadAndDisplayDoubleTile(type: tileType,  location: CGPoint){
        let node = SKSpriteNode(texture: tiles[type.description])
        node.size = CGSize(width: 32, height: 64)
        node.position = CGPoint(x: location.x, y: location.y + 16)
        node.zPosition = 1
        node.name = type.description

        worldLayer.addChild(node)
    }
    
    func centerCameraOnPoint(point: CGPoint) {
        if let camera = camera {
            camera.position = point
        }
    }
    func updateCameraScale() {
        if let camera = camera {
            camera.setScale(0.25)
        }
    }
    
    func addEntity(entity: GKEntity) {
        entities.insert(entity)
        if let spriteNode =
        entity.componentForClass(SpriteComponent.self)?.node {
            worldLayer.addChild(spriteNode)
        }
        for componentSystem in self.componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
    func addEntityToEnemyLayer(entity: GKEntity) {
        entities.insert(entity)
        if let spriteNode =
            entity.componentForClass(SpriteComponent.self)?.node {
                enemyLayer.addChild(spriteNode)
        }
        for componentSystem in self.componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == ColliderType.Boss.rawValue{

                playerEntity.moveComponent.stopPlayer()
                paused = true
                let scene = GameScene(size: CGSize(width: 1280, height: 800))
                scene.bossBattle = true
                scene.mapLevel = mapLevel
                scene.worldMapScene = self
                let transition = SKTransition.crossFadeWithDuration(2)
                view?.presentScene(scene, transition: transition)

        }
    }
    
    func playerMoved() {
        if(CGFloat(arc4random())/CGFloat(UInt32.max) < encounterSettings.encounterValue){
            playerEntity.moveComponent.stopPlayer()
            paused = true
            let scene = GameScene(size: CGSize(width: 1280, height: 800))
            scene.bossBattle = false
            scene.mapLevel = mapLevel
            scene.worldMapScene = self
            let transition = SKTransition.crossFadeWithDuration(2)
            view?.presentScene(scene, transition: transition)
        }
    }
    
    func labelDefaultSettings(label: SKLabelNode){
        label.fontColor = SKColor.blackColor()
        label.fontSize = 5.0
        label.fontName = "AvenirNext-Bold"
    }
    
}