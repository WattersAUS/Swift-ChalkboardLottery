//
//  Lottery.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 06/11/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import Foundation

class Lottery {
    
    private var number:  Numbers
    private var special: Numbers
    
    //
    // when we generate a new lottery combo, use this
    //
    init(nbrs: Int, nbrRange: NumberRange, spcs: Int, spcRange: NumberRange) {
        self.number  = Numbers(size: nbrs, limits: nbrRange)
        self.special = Numbers(size: spcs, limits: spcRange)
        return
    }
    
    //
    // used when we load historic draws (used as part of the 'Draws' class)
    //
    init(nbrs: [Int], nbrRange: NumberRange, spcs: [Int], spcRange: NumberRange) {
        self.number  = Numbers(size: nbrs.count, limits: nbrRange)
        for i: Int in 0..<nbrs.count {
            self.number.value[i] = nbrs[i]
        }
        self.special = Numbers(size: spcs.count, limits: spcRange)
        for i: Int in 0..<spcs.count {
            self.special.value[i] = spcs[i]
        }
        return
    }
    
    //
    // private function to generate numbers
    //
    private func generateValues(input: inout Numbers) {
        guard input.value.count > 0 else {
            return
        }
        
        func getUniqueNumber() -> Int {
            func randomNumber() -> Int {
                return (Int(arc4random_uniform(UInt32(input.range.upper - input.range.lower + 1)))) + input.range.lower
            }

            var unique: Int = randomNumber()
            while input.value.contains(unique) {
                unique = randomNumber()
            }
            return unique
        }

        for i: Int in 0 ..< input.value.count {
            input.value[i] = getUniqueNumber()
        }
        input.value.sort()
        return
    }
    
    //
    // public interface to generate numbers / special
    //
    func generateLotteryNumbers() {
        self.generateValues(input: &number)
        self.generateValues(input: &special)
        return
    }
    
    //
    // public functions - number level operations
    //
    func getNumber(position: Int) -> Int {
        guard (0..<self.number.value.count) ~= position else {
            return 0
        }
        return self.number.value[position]
    }
    
    func getNumbers() -> [Int] {
        var array: [Int] = []
        for item: Int in self.number.value {
            array.append(item)
        }
        return array
    }
    
    func getSpecial(position: Int) -> Int {
        guard (0..<self.special.value.count) ~= position else {
            return 0
        }
        return self.special.value[position]
    }
    
    func getSpecials() -> [Int] {
        var array: [Int] = []
        for item: Int in self.special.value {
            array.append(item)
        }
        return array
    }
}
