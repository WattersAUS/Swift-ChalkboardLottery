//
//  enumeration.swift
//  ChalkboardLottery
//
//  Created by Graham on 29/12/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

enum lotteryDraws: Int {
    case EuroMillions   = 1
    case Lotto          = 2
    case Thunderball    = 3
}

enum lotteryDictionary: String {
    case Ident          = "ident"
    case Description    = "description"
    case Numbers        = "numbers"
    case UpperNumber    = "upper_number"
    case Specials       = "specials"
    case UpperSpecial   = "upper_special"
    case LastModified   = "last_modified"
    case CountOfDraws   = "count_of_draws"
    case FirstDraw      = "first_draw"
    case FirstDrawDate  = "first_draw_date"
    case LastDraw       = "last_draw"
    case LastDrawDate   = "last_draw_date"
    case Draws          = "draws"
}

enum drawsDictionary: String {
    case Draw       = "draw"
    case DrawDate   = "draw_date"
    case Numbers    = "numbers"
    case Specials   = "specials"
}

enum valueDictionary: String {
    case Value = "value"
}
