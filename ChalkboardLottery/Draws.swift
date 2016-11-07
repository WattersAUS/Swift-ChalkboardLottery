//
//  Draws.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 07/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class Draws {

    struct LotteryDraws {
        var dateString: String
        var ltryDraw:   Lottery
        
        init(draw: [Int], date: String) {
//            ltryDrar = Lottery(nbrs: draw, nbrRange: , spcs: <#T##[Int]#>, spcRange: <#T##NumberRange#>)
            return
        }
    }
    var drawHistory: [LotteryDraws] = []
    
    var numberOfNumbers:  Int
    var numbersRange:     NumberRange
    var numberOfSpecials: Int
    var specialsRange:    NumberRange
    
    init(numbers: Int, numRange: NumberRange, specials: Int, spcRange: NumberRange) {
        self.numberOfNumbers  = numbers
        self.numbersRange     = NumberRange(upperLimit: numRange.upper, lowerLimit: numRange.lower)
        self.numberOfSpecials = specials
        self.specialsRange    = NumberRange(upperLimit: spcRange.upper, lowerLimit: spcRange.lower)
        return
    }
    
    func addDraw(numbers: [Int], specials: [Int]) {
//        drawHistory.append(LotteryDraws()
        return
    }
}
