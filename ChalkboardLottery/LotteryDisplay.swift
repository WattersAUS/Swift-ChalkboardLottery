//
//  LotteryDisplay.swift
//  ChalkboardLottery
//
//  Created by Graham on 21/02/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

struct Content {
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
    var ident:    lotteryIdent
    var numbers:  [Content] = []
    var specials: [Content] = []
    var bonuses:  [Content] = []
    var active:   Bool

    //----------------------------------------------------------------------------
    // Class: Constructors
    //----------------------------------------------------------------------------
    init () {
        self.ident    = lotteryIdent.Undefined
        self.numbers  = []
        self.specials = []
        self.bonuses  = []
        self.active   = false
        return
    }
    
    init (ident: lotteryIdent, numbers: [Int], specials: [Int], bonus: [Int], active: Bool) {
        self.ident  = ident
        self.numbers = []
        for no: Int in numbers {
            self.numbers.append(Content(displayNumber: no, displayType: numberDisplayType.Number))
        }
        self.specials = []
        for no: Int in specials {
            self.specials.append(Content(displayNumber: no, displayType: numberDisplayType.Special))
        }
        self.bonuses = []
        for no: Int in bonus {
            self.bonuses.append(Content(displayNumber: no, displayType: numberDisplayType.Bonus))
        }
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

    func clearBonuses() {
        for no: Int in 0 ..< self.bonuses.count {
            self.bonuses[no].displayNumber = 0
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
    
    func populateBonuses(bonuses: [Int]) {
        guard bonuses.count == self.bonuses.count else {
            return
        }
        self.clearBonuses()
        for no: Int in 0 ..< bonuses.count {
            self.bonuses[no].displayNumber = bonuses[no]
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
    
    func populateBonus(bonus: Int, position: Int) {
        guard self.bonuses.count <= position else {
            return
        }
        self.bonuses[position].displayNumber = bonus
        return
    }

}
