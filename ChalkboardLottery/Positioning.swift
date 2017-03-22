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
    var ident:                Int
    var numbers:              [CGRect] = []
    var specials:             [CGRect] = []
    var active:                Bool
    
    //----------------------------------------------------------------------------
    // Class: Constructors
    //----------------------------------------------------------------------------
    init (ident: Int, numberPositions: [CGRect], specialPositions: [CGRect], active: Bool) {
        self.ident  = ident
        self.numbers.append(contentsOf: numberPositions)
        self.specials.append(contentsOf: specialPositions)
        self.active = active
        return
    }
}
