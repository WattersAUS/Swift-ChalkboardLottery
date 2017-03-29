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
        self.displayLabel.textColor       = UIColor.white
        self.displayLabel.font            = UIFont(name: "Chalkboard", size: 10)
        //
        // use different bg colours for number types
        //
        switch displayType {
        case numberDisplayType.Number:
            self.displayLabel.backgroundColor = UIColor.blue
            break
        case numberDisplayType.Special:
            self.displayLabel.backgroundColor = UIColor.red
            break
        case numberDisplayType.Bonus:
            self.displayLabel.backgroundColor = UIColor.yellow
            break
        }
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
    func populateNumberArray(numbers: [Int]) {
        guard numbers.count == self.numbers.count else {
            return
        }
        self.clearNumbers()
        for no: Int in 0 ..< numbers.count {
            self.numbers[no].displayNumber = numbers[no]
        }
        return
    }
    
    func populateSpecialArray(specials: [Int]) {
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
    
    //----------------------------------------------------------------------------
    // Class: Private functions to hide / unhide number and special display
    //----------------------------------------------------------------------------
    private func hideNumberDisplay() {
        for i: LabelContent in self.numbers {
            i.displayLabel.isHidden  = false
            i.displayLabel.isEnabled = true
        }
        return
    }
    
    private func unHideNumberDisplay() {
        for i: LabelContent in self.numbers {
            i.displayLabel.isHidden  = true
            i.displayLabel.isEnabled = false
        }
        return
    }

    private func hideSpecialDisplay() {
        for i: LabelContent in self.specials {
            i.displayLabel.isHidden  = false
            i.displayLabel.isEnabled = true
        }
        return
    }
    
    private func unHideSpecialDisplay() {
        for i: LabelContent in self.specials {
            i.displayLabel.isHidden  = true
            i.displayLabel.isEnabled = false
        }
        return
    }
    //----------------------------------------------------------------------------
    // Class: Public functions to hide / unhide number and special display
    //----------------------------------------------------------------------------
    func hideDisplay() {
        self.hideNumberDisplay()
        self.hideSpecialDisplay()
        return
    }
    
    func unHideDisplay() {
        self.unHideNumberDisplay()
        self.unHideSpecialDisplay()
        return
    }
}
