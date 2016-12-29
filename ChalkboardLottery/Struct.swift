//
//  Struct.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

struct Draw {
    var draw:       Int
    var drawDate:   String
    var numbers:    [Int] = []
    var specials:   [Int] = []
}

struct LotteryDraw {
    var ident:          Int
    var description:    String
    var numbers:        Int
    var upperNumber:    Int
    var specials:       Int
    var upperSpecial:   Int
    var lastModified:   String
    var countOfDraws:   Int
    var firstDraw:      Int
    var firstDrawDate:  String
    var lastDraw:       Int
    var lastDrawDate:   String
    var draws:          [Draw]   = []
}

