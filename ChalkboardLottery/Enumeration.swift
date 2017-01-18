//
//  enumeration.swift
//  ChalkboardLottery
//
//  Created by Graham on 29/12/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

enum lotteryDraws: Int {
    case EuroMillions = 1
    case Lotto        = 2
    case Thunderball  = 3
}

enum jsonDictionary: String {
    case Version      = "version"
    case GenDate      = "generated"
    case Lottery      = "lottery"
    case Ident        = "ident"
    case Description  = "description"
    case Numbers      = "numbers"
    case UpperNumber  = "upper_number"
    case Specials     = "specials"
    case UpperSpecial = "upper_special"
    case LastModified = "last_modified"
    case Draws        = "draws"
    case Draw         = "draw"
    case DrawDate     = "draw_date"
    case Value        = "value"
}
