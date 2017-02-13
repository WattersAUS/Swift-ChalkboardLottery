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
    
    //----------------------------------------------------------------------------
    // Class: Constructors
    //----------------------------------------------------------------------------
    // when we setup the generator obj, we need arrays of the right size and limits set
    //
    init(number: Int, maxNumber: Int, special: Int, maxSpecial: Int) {
        self.numbers  = Numbers(number: number,  range: maxNumber)
        self.specials = Numbers(number: special, range: maxSpecial)
        return
    }
    
    init(number: Int, maxNumber: Int) {
        self.numbers  = Numbers(number: number,  range: maxNumber)
        self.specials = Numbers(number: 0,       range: 0)
        return
    }

    //----------------------------------------------------------------------------
    // Class: Private functions
    //----------------------------------------------------------------------------
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
                generated = Int(arc4random_uniform(UInt32(nos.upper))) + 1
            } while nos.numbers.contains(generated)
            return generated
        }
        
        clearNumbers()
        for i: Int in 0 ..< nos.numbers.count {
            nos.numbers[i] = newNumber()
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: Public functions
    //----------------------------------------------------------------------------
    //
    // build up the array, which should contain unique numbers through it
    //
    func generateNewLotteryNumbers() {
        self.generateNumbers(nos: &numbers)
        self.generateNumbers(nos: &specials)
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
    // return the number/special for the selected index
    //
    func getGeneratedNumber(index: Int) -> Int {
        guard (0..<self.numbers.numbers.count) ~= index  else {
            return 0
        }
        return self.numbers.numbers[index]
    }
    
    func getGeneratedSpecial(index: Int) -> Int {
        guard (0..<self.specials.numbers.count) ~= index  else {
            return 0
        }
        return self.specials.numbers[index]
    }
    
}
