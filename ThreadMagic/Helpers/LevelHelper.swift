//
//  LevelHelper.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 29/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

enum tileType: Int, CustomStringConvertible {
    case tileStart = 0
    //grass
    case tileGrass = 100
    //rock
    case tileRock0 = 101
    case tileRock1 = 102
    case tileRock2 = 103
    case tileRock3 = 104
    case tileRock4 = 105
    case tileRock5 = 106
    case tileRock6 = 107
    case tileRock7 = 108
    case tileRock8 = 109
    //stone
    case tileStone0 = 110
    case tileStone1 = 111
    case tileStone2 = 112
    case tileStone3 = 113
    case tileStone4 = 114
    case tileStone5 = 115
    case tileStone6 = 116
    case tileStone7 = 117
    case tileStone8 = 118
    //cliff
    case clifftop0 = 119
    case clifftop1 = 120
    case clifftop2 = 121
    case cliffbody0 = 122
    case cliffbody1 = 123
    case cliffbody2 = 124
    case cliffbody3 = 125
    case cliffbottom0 = 126
    case cliffbottom1 = 127
    case cliffbottom2 = 128
    //tree
    case tree0 = 129
    case tree1 = 130
    case tree2 = 131
    case tree3 = 132
    case tree4 = 133
    case tree5 = 134
    
    
    var description: String {
        switch self {
        case tileStart:
            return "grass"
        case tileGrass:
            return "grass"
        case tileRock0:
            return "rock0"
        case tileRock1:
            return "rock1"
        case tileRock2:
            return "rock2"
        case tileRock3:
            return "rock3"
        case tileRock4:
            return "rock4"
        case tileRock5:
            return "rock5"
        case tileRock6:
            return "rock6"
        case tileRock7:
            return "rock7"
        case tileRock8:
            return "rock8"
        case tileStone0:
            return "stone0"
        case tileStone1:
            return "stone1"
        case tileStone2:
            return "stone2"
        case tileStone3:
            return "stone3"
        case tileStone4:
            return "stone4"
        case tileStone5:
            return "stone5"
        case tileStone6:
            return "stone6"
        case tileStone7:
            return "stone7"
        case tileStone8:
            return "stone8"
            //cliff
        case clifftop0:
            return "clifftop0"
        case clifftop1:
            return "clifftop1"
        case clifftop2:
            return "clifftop2"
        case cliffbody0:
            return "cliffbody0"
        case cliffbody1:
            return "cliffbody1"
        case cliffbody2:
            return "cliffbody2"
        case cliffbody3:
            return "cliffbody3"
        case cliffbottom0:
            return "cliffbottom0"
        case cliffbottom1:
            return "cliffbottom1"
        case cliffbottom2:
            return "cliffbottom2"
        case tree0:
            return "tree0"
        case tree1:
            return "tree1"
            // 4 to a set tree
        case tree2:
            return "tree2"
        case tree3:
            return "tree3"
        case tree4:
            return "tree4"
        case tree5:
            return "tree5"
        }
    }
    
    var categoryBitMask: UInt32 {
        switch self {
        case tileStart:
            return ColliderType.None.rawValue
        case tileGrass:
            return ColliderType.Engage.rawValue
        case tileRock0:
            return ColliderType.Obstacle.rawValue
        case tileRock1:
            return ColliderType.Obstacle.rawValue
        case tileRock2:
            return ColliderType.Obstacle.rawValue
        case tileRock3:
            return ColliderType.Obstacle.rawValue
        case tileRock4:
            return ColliderType.Obstacle.rawValue
        case tileRock5:
            return ColliderType.Obstacle.rawValue
        case tileRock6:
            return ColliderType.Obstacle.rawValue
        case tileRock7:
            return ColliderType.Obstacle.rawValue
        case tileRock8:
            return ColliderType.Obstacle.rawValue
        case tileStone0:
            return ColliderType.Obstacle.rawValue
        case tileStone1:
            return ColliderType.Obstacle.rawValue
        case tileStone2:
            return ColliderType.Obstacle.rawValue
        case tileStone3:
            return ColliderType.Obstacle.rawValue
        case tileStone4:
            return ColliderType.Obstacle.rawValue
        case tileStone5:
            return ColliderType.Obstacle.rawValue
        case tileStone6:
            return ColliderType.Obstacle.rawValue
        case tileStone7:
            return ColliderType.Obstacle.rawValue
        case tileStone8:
            return ColliderType.Obstacle.rawValue
            //cliff
        case clifftop0:
            return ColliderType.Obstacle.rawValue
        case clifftop1:
            return ColliderType.Obstacle.rawValue
        case clifftop2:
            return ColliderType.Obstacle.rawValue
        case cliffbody0:
            return ColliderType.Obstacle.rawValue
        case cliffbody1:
            return ColliderType.Obstacle.rawValue
        case cliffbody2:
            return ColliderType.Obstacle.rawValue
        case cliffbody3:
            return ColliderType.Obstacle.rawValue
        case cliffbottom0:
            return ColliderType.Obstacle.rawValue
        case cliffbottom1:
            return ColliderType.Obstacle.rawValue
        case cliffbottom2:
            return ColliderType.Obstacle.rawValue
        case tree0:
            return ColliderType.Obstacle.rawValue
        case tree1:
            return ColliderType.Obstacle.rawValue
            // 4 to a set tree
        case tree2:
            return ColliderType.Obstacle.rawValue
        case tree3:
            return ColliderType.Obstacle.rawValue
        case tree4:
            return ColliderType.Obstacle.rawValue
        case tree5:
            return ColliderType.Obstacle.rawValue
        }
    }
}

protocol tileMapDelegate {
    func createNodeOf(type type: tileType, location: CGPoint)
}

struct tileMap {
    var delegate: tileMapDelegate?
    
    var tileSize = CGSize(width: 32, height: 32)
    
    var tileLayer: [[Int]] = Array()
    
    var mapSize = CGPoint(x: 47, y: 38)

    //MARK: Setters and getters for the tile map
    mutating func setTile(position position:CGPoint, toValue:Int) {
        tileLayer[Int(position.y)][Int(position.x)] = toValue
    }

    func getTile(position position:CGPoint) -> Int {
        return tileLayer[Int(position.y)][Int(position.x)]
    }

    func tilemapSize() -> CGSize {
        return CGSize(width: tileSize.width * mapSize.x, height:
        tileSize.height * mapSize.y)
    }
    
    
    mutating func generateLevel(defaultValue: Int) {
        var columnArray: [[Int]] = Array()
        
        repeat {
            var rowArray:[Int] = Array()
            repeat{
                rowArray.append(defaultValue)
            } while rowArray.count < Int(mapSize.x)
            columnArray.append(rowArray)
        } while columnArray.count < Int(mapSize.y)
        tileLayer = columnArray
    }
    
    func presentLayerViaDelegate() {
        for (indexr, row) in tileLayer.enumerate() {
            for (indexc, cvalue) in row.enumerate() {
                if (delegate != nil) {
                    delegate!.createNodeOf(type: tileType(rawValue: cvalue)!,
                    location: CGPoint(
                        x: tileSize.width * CGFloat(indexc),
                        y: tileSize.height * CGFloat(-indexr)))
                }
            }
        }
    }

    //MARK: Level creation
    
    mutating func generateMap(mapLevel: MapLevel) {
        
        var template = LevelTemplate(rawValue: mapLevel.rawValue)!.template
        //Set tiles based on template
        for (indexr, row) in template.enumerate() {
            for (indexc, cvalue) in row.enumerate() {
                setTile(position: CGPoint(x: indexc, y:indexr), toValue: cvalue)
            }
        }
    }
}
