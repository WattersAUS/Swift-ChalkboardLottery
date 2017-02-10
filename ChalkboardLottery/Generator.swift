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
        self.numbers  = Numbers(number: number,  range: maxNumber)
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
    // usage: generateNumbers(nos: &numbers)
    //
    private func generateNumbers(nos: inout Numbers) {
        
        func clearNumbers() {
            for i: Int in 0 ..< nos.numbers.count {
                nos.numbers[i] = 0
            }
            return
        }
        
        func newNumber() -> Int {
            var generated: Int
            repeat {
                generated = Int(arc4random_uniform(UInt32(nos.upper)))
            } while nos.numbers.contains(generated)
            return generated
        }
        
        clearNumbers()
        for i: Int in 0 ..< nos.numbers.count {
            nos.numbers[i] = newNumber()
        }
        return
    }
    
    func generateNewLotteryNumbers() {
        self.generateNumbers(nos: &numbers)
        self.generateNumbers(nos: &specials)
        return
    }
    
}
