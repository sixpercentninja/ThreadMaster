//
//  SkillHelper.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 01/03/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

enum SkillType: String {
    case spiderWeb  = "SpiderWeb"
    case whip       = "Whip"
    case constrict  = "Constrict"
    case thrash     = "Thrash"
    case aramidWard = "AramidWard"
    case aramidGuard = "AramidGuard"
    case aegisLastStand = "AegisLastStand"
    case cottonFlare    = "CottonFlare"
    case cottonBlaze    = "CottonBlaze"
    case wildFire       = "WildFire"
    case silkTrick      = "SilkTrick"
    case silkDaze       = "SilkDaze"
    case pieceDeResistance = "PieceDeResistance"
    case rayonStrike        = "RayonStrike"
    case rayonBash          = "RayonBash"
    case kusanagiNoTsurugi  = "KusanogiNoTsurugi"
    
    static let allSkills = [spiderWeb, whip, constrict, thrash, aramidWard, aramidGuard, aegisLastStand, cottonFlare, cottonBlaze, wildFire, silkTrick, silkDaze, pieceDeResistance, rayonStrike, rayonBash, kusanagiNoTsurugi,]
    
    var singleInstance: Skill {
        switch self {
        case spiderWeb:
            return SpiderWeb()
        case whip:
            return Whip()
        case constrict:
            return Constrict()
        case thrash:
            return Thrash()
        case aramidWard:
            return AramidWard()
        case aramidGuard:
            return AramidGuard()
        case aegisLastStand:
            return AegisLastStand()
        case cottonFlare:
            return CottonFlare()
        case cottonBlaze:
            return CottonBlaze()
        case wildFire:
            return WildFire()
        case silkTrick:
            return SilkTrick()
        case silkDaze:
            return SilkDaze()
        case pieceDeResistance:
            return PieceDeResistance()
        case rayonStrike:
            return RayonStrike()
        case rayonBash:
            return RayonBash()
        case kusanagiNoTsurugi:
            return KusanagiNoTsurugi()
        }
    }
}