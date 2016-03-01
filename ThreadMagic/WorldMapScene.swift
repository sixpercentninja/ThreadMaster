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

class WorldMapScene: SKScene, tileMapDelegate, SKPhysicsContactDelegate {
    var worldGen = tileMap()
    //Layers
    var worldLayer = SKNode()
    var guiLayer = SKNode()
    var enemyLayer = SKNode()
    var overlayLayer = SKNode()
    let atlasTiles = SKTextureAtlas(named: "Tiles")
    var entities = Set<GKEntity>()
    
    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0
    var lastDeltaTime: NSTimeInterval = 0
    
    let playerEntity = PlayerEntity()
    
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass:
        AnimationComponent.self)
        let playerMoveSystem = GKComponentSystem(componentClass:
        PlayerMoveComponent.self)
        return [animationSystem, playerMoveSystem]
    }()
    
    override func didMoveToView(view: SKView) {
        //Delegates
        worldGen.delegate = self
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        //Setup Camera
        let myCamera = SKCameraNode()
        camera = myCamera
        addChild(myCamera)
        updateCameraScale()
        
        //Config World
        addChild(worldLayer)
        camera!.addChild(guiLayer)
        guiLayer.addChild(overlayLayer)
        worldLayer.addChild(enemyLayer)
        
        setupLevel()
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        var deltaTime = currentTime - lastUpdateTimeInterval
        deltaTime = deltaTime > maximumUpdateDeltaTime ?
        maximumUpdateDeltaTime : deltaTime
        lastUpdateTimeInterval = currentTime
        //Update all components
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
        
        if let player = worldLayer.childNodeWithName("playerNode") as? EntityNode
        {
            centerCameraOnPoint(player.position)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        sceneTouched(location)
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
        worldGen.generateLevel(0)
        worldGen.generateMap()
        worldGen.presentLayerViaDelegate()
    }
    
    func createNodeOf(type type: tileType, location: CGPoint) {
        switch type {
        case .tree0, .tree1, .tree2, .tree3, .tree4, .tree5:
            loadAndDisplayDoubleTile(type, location: location)
        case .tileStart:
            loadAndDisplaySingleTile(type, location: location)
            
            let playerNode = playerEntity.spriteComponent.node
            playerNode.position = location
            playerNode.name = "playerNode"
            playerNode.zPosition = 50
            playerNode.anchorPoint = CGPointMake(0.5, 0.2)
            playerEntity.animationComponent.requestedAnimationState = .Walk_Down
            addEntity(playerEntity)
        default:
            loadAndDisplaySingleTile(type, location: location)
            break
        }
    }
    
    func loadAndDisplaySingleTile(type: tileType, location: CGPoint){
        let node = SKSpriteNode(texture: atlasTiles.textureNamed(type.description))
        node.size = CGSize(width: 32, height: 32)
        node.position = location
        node.zPosition = 1
        node.name = type.description
        node.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:
            CGPoint(x: -16, y: -16), size: CGSize(width: 32, height: 32)))
        node.physicsBody?.categoryBitMask = type.categoryBitMask
        worldLayer.addChild(node)
    }
    
    func loadAndDisplayDoubleTile(type: tileType,  location: CGPoint){
        let node = SKSpriteNode(texture: atlasTiles.textureNamed(type.description))
        node.size = CGSize(width: 32, height: 64)
        node.position = CGPoint(x: location.x, y: location.y + 16)
        node.zPosition = 1
        node.name = type.description
        node.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:
            CGPoint(x: -16, y: -32), size: CGSize(width: 32, height: 32)))
        node.physicsBody?.categoryBitMask = type.categoryBitMask

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
}