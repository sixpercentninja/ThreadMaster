//
//  LogBase.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 26/02/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import Foundation

public func logWithBase(base: Double, value: Double) -> Double{
    return log(value) / log(base);
}

public func randomNumberBetween(start: Int, end: Int) -> Int{
    let range = end - start
    return Int(arc4random_uniform(UInt32(range))) + start
}