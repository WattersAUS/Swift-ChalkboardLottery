//
//  LabelPositioning.swift
//  ChalkboardLottery
//
//  Created by Graham on 20/03/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

class Positioning {
//
//    var orientation: screenOrientation = screenOrientation.Portrait
//    
    var ident:                lotteryIdent
    var numbers:              [CGRect] = []
    var specials:             [CGRect] = []
    var bonuses:              [CGRect] = []
    var active:                Bool
    
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
        for _: Int in numbers {
            self.numbers.append(CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        self.specials = []
        for _: Int in specials {
            self.numbers.append(CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        self.bonuses = []
        for _: Int in bonus {
            self.numbers.append(CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        self.active = active
        return
    }
}
