//
//  Positioning.swift
//  ChalkboardLottery
//
//  Created by Graham on 20/03/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//

import Foundation
import UIKit

class Positioning {
    var ident:                lotteryIdent
    var numbers:              [CGRect] = []
    var specials:             [CGRect] = []
    var visible:               Bool
    
    //----------------------------------------------------------------------------
    // Class: Constructors
    //----------------------------------------------------------------------------
    init (ident: lotteryIdent, numberPositions: [CGRect], specialPositions: [CGRect], active: Bool) {
        self.ident  = ident
        self.numbers.append(contentsOf: numberPositions)
        self.specials.append(contentsOf: specialPositions)
        self.visible = active
        return
    }
}
