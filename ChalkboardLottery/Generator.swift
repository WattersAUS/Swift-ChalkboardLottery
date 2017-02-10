//
//  Generator.swift
//  ChalkboardLottery
//
//  Created by Graham on 10/02/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//

import Foundation

class Generator {
    private var numbers:  Numbers
    private var specials: Numbers
    
    //
    // when we setup the generator obj, we need arrays of the right size and limits set
    //
    init(number: Int, maxNumber: Int, special: Int, maxSpecial: Int) {
        self.numbers  = Numbers(number: number, range: maxNumber)
        self.specials = Numbers(number: special, range: maxSpecial)
        return
    }
    
    //
    // get the range for numbers (may be deprecated)
    //
    func getMaxNumber() -> Int {
        return self.numbers.upper
    }
    
    func getMaxSpecial() -> Int {
        return self.specials.upper
    }
    
    //
    // generate numbers randomly
    //
    func generateRandomNumbers() {
        
        return
    }
}
