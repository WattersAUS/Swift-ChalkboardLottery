//
//  enumeration.swift
//  ChalkboardLottery
//
//  Created by Graham on 29/12/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

enum app: String {
    case Version = "v1.00"
    
}

//
// Draws configured by default in the system, user configured draws will be id => 4
//
enum lotteryIdent: Int {
    case Undefined    = 0
    case EuroMillions = 1
    case Lotto        = 2
    case Thunderball  = 3
    case UserDefined  = 4
}

//
// JSON supporting draws configured (both original r/o and user generated r/w)
// This will be stored as a string within UserPreferences
//
enum jsonLocal: String {
    case Version      = "version"
    case Lottery      = "lottery"
    case Ident        = "id"
    case Description  = "desc"
    case Numbers      = "nos"
    case UpperNumber  = "upper_nos"
    case Specials     = "spc"
    case UpperSpecial = "upper_spc"
    case Modified     = "modified"
    case Bonus        = "bonus"
    case Days         = "days"
    case Active       = "active"
    case Draws        = "draws"
    case DrawDate     = "date"
}

//
// JSON downloaded containing Lottery Draw Results
//
enum jsonOnline: String {
    case Version      = "version"
    case GenDate      = "generated"
    case Lottery      = "lottery"
    case Ident        = "id"
    case Description  = "desc"
    case Numbers      = "nos"
    case UpperNumber  = "upper_nos"
    case Specials     = "spc"
    case UpperSpecial = "upper_spc"
    case Bonus        = "bonus"
    case LastModified = "modified"
    case Draws        = "draws"
    case Draw         = "draw"
    case DrawDate     = "date"
}

//
// types of numbers we will display on the interface
//
enum numberDisplayType: Int {
    case Number  = 1
    case Special = 2
    case Bonus   = 3
}

//
// what objs can we support within the Tap Detection struct
//
enum tapObject: Int {
    case tab   = 1
    case label = 2
    case image = 3
}

