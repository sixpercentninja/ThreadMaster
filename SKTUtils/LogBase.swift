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