//
//  WetTowelSlap.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 18/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation

class WetTowelSlap: Skill {
    override class var damage: Int { return 20 }
    override class var attackAttribute: Attribute { return Attribute.Resistance }
    
}