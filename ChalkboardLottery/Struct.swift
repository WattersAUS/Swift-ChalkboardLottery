//
//  Struct.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

//
// generic struct to support Numbers / Specials in both User and Online draws
//
struct Numbers {
    var numbers: [Int] = []
    var upper:    Int
    
    init(number: Int, range: Int) {
        for _: Int in 0 ..< ((number < 1) ? 1 : number) {
            numbers.append(0)
        }
        upper = ((range < number) ? number : range)
        return
    }
}

//
// extend from these base protocols
//
protocol Draw {
    var date:     String { get set }
    var numbers:  [Int]  { get set }
    var specials: [Int]  { get set }
}

protocol Lottery {
    var ident:        Int     { get set }
    var description:  String  { get set }
    var numbers:      Int     { get set }
    var upperNumber:  Int     { get set }
    var specials:     Int     { get set }
    var upperSpecial: Int     { get set }
}

//
// define default draw structs
//
struct UserDraw: Draw {
    var date:     String
    var numbers:  [Int]
    var specials: [Int]
    
    init() {
        date     = ""
        numbers  = []
        specials = []
        return
    }
    
    init(drawDate: String, numberArray: [Int], specialArray: [Int]) {
        date     = drawDate
        numbers  = []
        numbers.append(contentsOf: numberArray)
        specials = []
        specials.append(contentsOf: numberArray)
        return
    }
}

//
// lottery config to support data stored in prefs
//
struct ConfigLottery: Lottery {
    var version:      String
    var ident:        Int
    var description:  String
    var numbers:      Int
    var upperNumber:  Int
    var specials:     Int
    var upperSpecial: Int
    
    var bonus:        Bool
    var days:         [Int]
    var readonly:     Bool
    var active:       Bool

    var draws:        [UserDraw]
    
    init() {
        version      = app.Version.rawValue
        ident        = 0
        description  = ""
        numbers      = 0
        upperNumber  = 0
        specials     = 0
        upperSpecial = 0
        bonus        = false
        days         = []
        readonly     = true
        active       = true
        draws        = []
        return
    }

    init(newIdent: Int, newDescription: String, newNumbers: Int, newUpperNumber: Int, newSpecials: Int, newUpperSpecial: Int, newBonus: Bool, newDays: [Int]) {
        version      = app.Version.rawValue
        ident        = newIdent
        description  = newDescription
        numbers      = newNumbers
        upperNumber  = newUpperNumber
        specials     = newSpecials
        upperSpecial = newUpperSpecial
        bonus        = newBonus
        days         = []
        days.append(contentsOf: newDays)
        readonly     = false
        active       = true
        draws        = []
        return
    }

    init(newIdent: Int, newDescription: String, newNumbers: Int, newUpperNumber: Int, newSpecials: Int, newUpperSpecial: Int, newBonus: Bool, newDays: [Int], newReadOnly: Bool, newActive: Bool) {
        version      = app.Version.rawValue
        ident        = newIdent
        description  = newDescription
        numbers      = newNumbers
        upperNumber  = newUpperNumber
        specials     = newSpecials
        upperSpecial = newUpperSpecial
        bonus        = newBonus
        days         = []
        days.append(contentsOf: newDays)
        readonly     = newReadOnly
        active       = newActive
        draws        = []
        return
    }
    
    mutating func clearLotteryDraws() {
        draws = []
        return
    }
    
    mutating func addLotteryDraw(draw: UserDraw) {
        draws.append(draw)
        return
    }

    mutating func addLotteryDraws(drawArray: [UserDraw]) {
        draws.append(contentsOf: drawArray)
        return
    }
}

//
// structures to support the 'historic' online lottery/draw storage
//
struct OnlineDraw: Draw {
    var draw:     Int
    var date:     String
    var numbers:  [Int]
    var specials: [Int]
    
    init() {
        draw     = 0
        date     = ""
        numbers  = []
        specials = []
        return
    }

    init(drawNumber: Int, drawDate: String, numberArray: [Int], specialArray: [Int]) {
        draw     = drawNumber
        date     = drawDate
        numbers  = []
        numbers.append(contentsOf: numberArray)
        specials = []
        specials.append(contentsOf: numberArray)
        return
    }
}

struct OnlineLottery: Lottery {
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
        return
    }

    init(newIdent: Int, newDescription: String, newNumbers: Int, newUpperNumber: Int, newSpecials: Int, newUpperSpecial: Int, newStartDate: String) {
        ident        = newIdent
        description  = newDescription
        numbers      = newNumbers
        upperNumber  = newUpperNumber
        specials     = newSpecials
        upperSpecial = newUpperSpecial
        lastModified = newStartDate
        draws        = []
        return
    }
    

    
    
    mutating func clearLotteryDraws() {
        draws = []
        return
    }
    
    mutating func addLotteryDraw(draw: OnlineDraw) {
        draws.append(draw)
        return
    }
    
    mutating func addLotteryDraws(drawArray: [OnlineDraw]) {
        draws.append(contentsOf: drawArray)
        return
    }
}

struct OnlineHistory {
    var version:   String
    var generated: String
    var lotteries: [OnlineLottery]
    
    init() {
        version   = ""
        generated = ""
        lotteries = []
        return
    }
    
    mutating func clearLotterie() {
        lotteries = []
        return
    }
    
    mutating func addLotteryDraw(lottery: OnlineLottery) {
        lotteries.append(lottery)
        return
    }
    
    mutating func addLotteryDraws(lotteryArray: [OnlineLottery]) {
        lotteries.append(contentsOf: lotteryArray)
        return
    }
}

//
// traverse this list to determine what the user 'tapped' on the screen
//
struct TapDetect {
    var typeObj:   tapObject
    var location:  CGPoint
    var function:  (Void) -> ()
    var activeObj: Bool
    
    init(type: tapObject, loc: CGPoint, funct: @escaping (Void) -> (), active: Bool) {
        typeObj  = type
        location = loc
        function = funct
        activeObj = active
        return
    }
}

struct ControlList {
    var objs:      [TapDetect]
    var activeObj: Int
    
    init () {
        objs      = []
        activeObj = -1
        return
    }
    
    mutating func clearLotterie() {
        objs = []
        return
    }
    
    mutating func addTapObject(tapObj: TapDetect) {
        objs.append(tapObj)
        return
    }
    
    mutating func addTapObjects(tapObjs: [TapDetect]) {
        objs.append(contentsOf: tapObjs)
        return
    }
}

//
// eol
//
