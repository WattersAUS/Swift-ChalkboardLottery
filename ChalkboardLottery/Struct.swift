//
//  Struct.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

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

