//
//  GameSettings.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 29/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation
import SpriteKit


enum AnimationState: String {
    case Idle_Down = "Idle_12"
    case Idle_Up = "Idle_4"
    case Idle_Left = "Idle_8"
    case Idle_Right = "Idle_0"
    case Walk_Down = "Walk_12"
    case Walk_Up = "Walk_4"
    case Walk_Left = "Walk_8"
    case Walk_Right = "Walk_0"
}

enum LastDirection {
    case Left
    case Right
    case Up
    case Down
}

struct playerSettings {
    //Player
    static let movementSpeed: CGFloat = 250.0
}

struct encounterSettings{
    static let encounterValue: CGFloat = 0.01
}

enum ColliderType:UInt32 {
    case Player         = 0
    case None           = 0b1
    case Engage         = 0b10
    case Obstacle       = 0b100
    case Boss           = 0b1000
}

enum MapLevel: Int {
    case levelOne = 0
    case levelTwo = 1
    case levelThree = 2
    case levelFour = 3
    case levelFive = 4
    
    var monsters: [Monster.Type] {
        switch self {
        case .levelOne:
            return [Kiba.self, VenomViper.self]
        case .levelTwo:
            return [Megalith.self, OgreFiend.self, Kiba.self, VenomViper.self]
        case .levelThree:
            return [UndeadKnight.self, FrostWyvern.self]
        case .levelFour:
            return [WickedElder.self, Sorcerer.self, UndeadKnight.self, FrostWyvern.self]
        case .levelFive:
            return [WickedElder.self, Sorcerer.self, DemonTengu.self]
        }
    }
    
    var boss: Monster.Type {
        switch self {
        case .levelOne:
            return Gabino.self
        case .levelTwo:
            return Edan.self
        case .levelThree:
            return Oinari.self
        case .levelFour:
            return Charon.self
        case .levelFive:
            return Charon.self
        }
    }
    
    var bossImage: String {
        switch self {
        case .levelOne:
            return "Gabino"
        case .levelTwo:
            return "Edan"
        case .levelThree:
            return "Oinari"
        case .levelFour:
            return "Charon"
        case .levelFive:
            return "Charon"
        }
    }
    
    var randomMonster: Monster.Type {
        let randomIndex = Int(arc4random_uniform(UInt32(monsters.count)))
        return monsters[randomIndex]
    }
}