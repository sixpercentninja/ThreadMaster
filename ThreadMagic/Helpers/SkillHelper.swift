//
//  SkillHelper.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 01/03/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import SpriteKit

enum SkillType: String {
    case spiderWeb  = "Spider Web"
    case whip       = "Whip"
    case constrict  = "Constrict"
    case thrash     = "Thrash"
    case aramidWard = "Aramid Ward"
    case aramidGuard = "Aramid Guard"
    case aegisLastStand = "Aegis' Last Stand"
    case cottonFlare    = "Cotton Flare"
    case cottonBlaze    = "Cotton Blaze"
    case wildFire       = "Wild Fire"
    case silkTrick      = "Silk Trick"
    case silkDaze       = "Silk Daze"
    case pieceDeResistance = "Pièce de Résistance"
    case rayonStrike        = "Rayon Strike"
    case rayonBash          = "Rayon Bash"
    case kusanagiNoTsurugi  = "Kusanogi No Tsurugi"
    
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