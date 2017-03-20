//
//  LotteryDisplay.swift
//  ChalkboardLottery
//
//  Created by Graham on 21/02/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

struct LabelContent {
    var displayLabel:  UILabel!
    var displayNumber: Int
    var displayType:   numberDisplayType
    
    init (displayNumber: Int, displayType: numberDisplayType) {
        //
        // DEBUG FOR POSNING HERE!!!! FONT SIZE MAY NEED CHANGING ON DIFFERENT SCREENS
        //
        self.displayLabel                 = UILabel()
        self.displayLabel.font            = UIFont(name: "Chalkboard", size: 10)
        self.displayLabel.backgroundColor = UIColor.red
        //
        self.displayNumber = displayNumber
        self.displayType   = displayType
    }
}

class LotteryDisplay {
    var ident:    Int
    var numbers:  [LabelContent] = []
    var specials: [LabelContent] = []
    var bonus:    Bool
    var active:   Bool

    //----------------------------------------------------------------------------
    // Class: Constructors
    //----------------------------------------------------------------------------
    init () {
        self.ident    = 0
        self.numbers  = []
        self.specials = []
        self.bonus    = false
        self.active   = false
        return
    }
    
    init (ident: Int, numbers: Int, specials: Int, bonus: Bool, active: Bool) {
        self.ident  = ident
        self.numbers = []
        for _: Int in 0 ..< numbers {
            self.numbers.append(LabelContent(displayNumber: 0, displayType: numberDisplayType.Number))
        }
        self.specials = []
        for _: Int in 0 ..< specials {
            self.specials.append(LabelContent(displayNumber: 0, displayType: numberDisplayType.Special))
        }
        self.bonus  = bonus
        self.active = active
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: Public functions to clear all numbers in the array
    //----------------------------------------------------------------------------
    func clearNumbers() {
        for no: Int in 0 ..< self.numbers.count {
            self.numbers[no].displayNumber = 0
        }
        return
    }
    
    func clearSpecials() {
        for no: Int in 0 ..< self.specials.count {
            self.specials[no].displayNumber = 0
        }
        return
    }

    //----------------------------------------------------------------------------
    // Class: Public functions to enable number array population in one go
    //----------------------------------------------------------------------------
    func populateNumbers(numbers: [Int]) {
        guard numbers.count == self.numbers.count else {
            return
        }
        self.clearNumbers()
        for no: Int in 0 ..< numbers.count {
            self.numbers[no].displayNumber = numbers[no]
        }
        return
    }
    
    func populateSpecials(specials: [Int]) {
        guard specials.count == self.specials.count else {
            return
        }
        self.clearSpecials()
        for no: Int in 0 ..< specials.count {
            self.specials[no].displayNumber = specials[no]
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: Public functions to enable individual number population by position
    //----------------------------------------------------------------------------
    func populateNumber(number: Int, position: Int) {
        guard self.numbers.count <= position else {
            return
        }
        self.numbers[position].displayNumber = number
        return
    }
    
    func populateSpecial(special: Int, position: Int) {
        guard self.specials.count <= position else {
            return
        }
        self.specials[position].displayNumber = special
        return
    }
    
}
