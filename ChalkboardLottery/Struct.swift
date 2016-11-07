//
//  Struct.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

struct NumberRange {
    var upper: Int
    var lower: Int
    
    init(upperLimit: Int, lowerLimit: Int) {
        upper = upperLimit
        lower = lowerLimit
        return
    }
}

struct Numbers {
    var value: [Int] = []
    var range: NumberRange
    
    init(size: Int, limits: NumberRange) {
        for _: Int in 0..<size {
            value.append(limits.lower - 1)
        }
        range = limits
        return
    }
}
