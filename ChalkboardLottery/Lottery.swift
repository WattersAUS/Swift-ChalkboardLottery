//
//  Lottery.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

struct Range {
    var upper: Int
    var lower: Int
    
    init (upperLimit: Int, lowerLimit: Int) {
        upper = upperLimit
        lower = lowerLimit
        return
    }
}

struct Numbers {
    var value: [Int] = []
    var range: Range
    
    init(size: Int, limits: Range) {
        for _: Int in 0..<size {
            value.append(limits.lower - 1)
        }
        range = limits
    }
}

class Lottery: NSObject {
    
    private var number:  Numbers
    private var special: Numbers
    
    init (nbrs: Int, nbrRange: Range, spcs: Int, spcRange: Range) {
        self.number  = Numbers(size: nbrs, limits: nbrRange)
        self.special = Numbers(size: spcs, limits: spcRange)
        return
    }
    
    //
    // public functions - number level operations
    //
    func getNumber(position: Int) -> Int {
        guard (0..<self.number.value.count) ~= position else {
            return 0
        }
        return self.number.value[position]
    }
    
    func getNumbers() -> [Int] {
        var array: [Int] = []
        for item: Int in self.number.value {
            array.append(item)
        }
        return array
    }
    
    func getSpecial(position: Int) -> Int {
        guard (0..<self.special.value.count) ~= position else {
            return 0
        }
        return self.special.value[position]
    }
    
    func getSpecials() -> [Int] {
        var array: [Int] = []
        for item: Int in self.special.value {
            array.append(item)
        }
        return array
    }
    
}
