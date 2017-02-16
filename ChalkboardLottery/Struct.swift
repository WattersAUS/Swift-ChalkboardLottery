//
//  Struct.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

//
// generic struct to support Numbers / Specials as both are arrays and have a max value
//
struct Numbers {
    var numbers: [Int] = []
    var upper:    Int
    
    init(number: Int, range: Int) {
        for _: Int in 0 ..< ((number < 1) ? 1 : number) {
            numbers.append(0)
        }
        upper = ((range < number) ? number : range)
    }
}

//
// config structs
//
struct UserDraw {
    var drawDate: String
    var numbers:  [Int]
    var specials: [Int]
    
    init() {
        drawDate = ""
        numbers  = []
        specials = []
    }
}

struct ConfigLotteryInstance {
    var ident:        Int
    var description:  String
    var numbers:      Int
    var upperNumber:  Int
    var specials:     Int
    var upperSpecial: Int
    var bonus:        Int
    var days:         [Int]
    var limit:        Int
    var start:        String
    var readonly:     Bool
    var active:       Bool
    var draws:        [UserDraw]
    
    init() {
        ident        = 0
        description  = ""
        numbers      = 0
        upperNumber  = 0
        specials     = 0
        upperSpecial = 0
        bonus        = 0
        days         = []
        limit        = 0
        start        = ""
        readonly     = true
        active       = true
        draws        = []
    }
}

//
// structures to support the 'historic' online storage
//
struct OnlineDraw {
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

struct OnlineLotteryInstance {
    var ident:        Int
    var description:  String
    var numbers:      Int
    var upperNumber:  Int
    var specials:     Int
    var upperSpecial: Int
    var lastModified: String
    var draws:        [OnlineDraw]
    
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

struct OnlineHistory {
    var version:   String
    var generated: String
    var lotteries: [OnlineLotteryInstance]
    
    init() {
        version   = ""
        generated = ""
        lotteries = []
    }
}
