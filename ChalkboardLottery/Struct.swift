//
//  Struct.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

//
// structures to support the 'historic' storage
//
struct Draw {
    var draw:     Int
    var drawDate: String
    var numbers:  [Int]
    var specials: [Int]
    
    init() {
        draw     = 0
        drawDate = ""
        numbers  = []
        specials = []
    }
}

struct LotteryInstance {
    var ident:        Int
    var description:  String
    var numbers:      Int
    var upperNumber:  Int
    var specials:     Int
    var upperSpecial: Int
    var lastModified: String
    var draws:        [Draw]
    
    init() {
        ident        = 0
        description  = ""
        numbers      = 0
        upperNumber  = 0
        specials     = 0
        upperSpecial = 0
        lastModified = ""
        draws        = []
    }
}

struct History {
    var lotteries: [LotteryInstance]
    var generated: String
    var version:   String
    
    init() {
        lotteries = []
        generated = ""
        version   = ""
    }
}

//
// generic struct to support Numbers / Specials as both are arrays and have a max value
//
struct Numbers {
    var numbers: [Int] = []
    var upper:    Int

    init(number: Int, range: Int) {
        for _: Int in 0 ..< ((number == 0) ? 1 : number) {
            numbers.append(0)
        }
        upper = ((range == 0) ? 1 : range)
    }
}
