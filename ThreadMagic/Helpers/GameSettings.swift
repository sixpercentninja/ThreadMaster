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
}

enum MapLevel: Int {
    case LevelOne = 0
    case LevelTwo = 1
    case LevelThree = 3
    case LevelFour = 4
}