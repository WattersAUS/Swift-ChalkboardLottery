//
//  enumeration.swift
//  ChalkboardLottery
//
//  Created by Graham on 29/12/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

enum lotteryIdent: Int {
    case EuroMillions = 1
    case Lotto        = 2
    case Thunderball  = 3
}

enum jsonDictionary: String {
    case Version      = "version"
    case GenDate      = "generated"
    case Lottery      = "lottery"
    case Ident        = "id"
    case Description  = "desc"
    case Numbers      = "nos"
    case UpperNumber  = "upper_nos"
    case Specials     = "spc"
    case UpperSpecial = "upper_spc"
    case LastModified = "modified"
    case Draws        = "draws"
    case Draw         = "draw"
    case DrawDate     = "date"
    case Value        = "v"
}
