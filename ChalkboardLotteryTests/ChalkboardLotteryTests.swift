//
//  ChalkboardLotteryTests.swift
//  ChalkboardLotteryTests
//
//  Created by Graham Watson on 13/09/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import XCTest

@testable import ChalkboardLottery

class ChalkboardLotteryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //----------------------------------------------------------------------------
    // Struct: Numbers
    //----------------------------------------------------------------------------
    func testNumbersConstructor_Test1() {
        let nbr: Numbers = Numbers(number: 5, range: 5)
        //
        // test array initialised
        //
        XCTAssertEqual(nbr.numbers[0], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[1], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[2], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[3], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[4], 0, "Incorrect number initialisation reported!")
        //
        // max possible number returned
        //
        XCTAssertEqual(nbr.upper, 5, "Incorrect number upper limit reported!")
        return
    }
    
    func testNumbersConstructor_Test2() {
        let nbr: Numbers = Numbers(number: 5, range: 0)
        //
        // test array initialised
        //
        XCTAssertEqual(nbr.numbers[0], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[1], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[2], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[3], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[4], 0, "Incorrect number initialisation reported!")
        //
        // max possible number returned, this should be corrected as the range cannot < number
        //
        XCTAssertEqual(nbr.upper, 5, "Incorrect number upper limit reported!")
        return
    }
    
    func testNumbersConstructor_Test3() {
        let nbr: Numbers = Numbers(number: 7, range: 10)
        //
        // test array initialised
        //
        XCTAssertEqual(nbr.numbers[0], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[1], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[2], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[3], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[4], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[5], 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(nbr.numbers[6], 0, "Incorrect number initialisation reported!")
        //
        // max possible number returned, this should be corrected as the range cannot < number
        //
        XCTAssertEqual(nbr.upper, 10, "Incorrect number upper limit reported!")
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: Generator - used to generate array of numbers
    //----------------------------------------------------------------------------
    func testGeneratorConstructor_1() {
        let gen: Generator = Generator(number: 3, maxNumber: 3, special: 2, maxSpecial: 2)
        //
        // First all possible numbers / specials must be initialised
        //
        XCTAssertEqual(gen.getGeneratedNumber(index:  0), 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(gen.getGeneratedNumber(index:  1), 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(gen.getGeneratedNumber(index:  2), 0, "Incorrect number initialisation reported!")
        //
        XCTAssertEqual(gen.getGeneratedSpecial(index: 0), 0, "Incorrect special initialisation reported!")
        XCTAssertEqual(gen.getGeneratedSpecial(index: 1), 0, "Incorrect special initialisation reported!")
        //
        // an out of range index should report 0
        //
        XCTAssertEqual(gen.getGeneratedNumber(index:  3), 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(gen.getGeneratedSpecial(index: 2), 0, "Incorrect special initialisation reported!")
        XCTAssertEqual(gen.getGeneratedNumber(index:  0), 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(gen.getGeneratedSpecial(index: 0), 0, "Incorrect special initialisation reported!")
        //
        // test upper limits set appropriately
        //
        XCTAssertEqual(gen.getPossibleMaximumNumber(),  3, "Incorrect maximum number limit reported!")
        XCTAssertEqual(gen.getPossibleMaximumSpecial(), 2, "Incorrect maximum special limit reported!")
        return
    }

    func testGeneratorConstructor_2() {
        let gen: Generator = Generator(number: 3, maxNumber: 3)
        //
        // First all possible numbers / specials must be initialised
        //
        XCTAssertEqual(gen.getGeneratedNumber(index:  0), 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(gen.getGeneratedNumber(index:  1), 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(gen.getGeneratedNumber(index:  2), 0, "Incorrect number initialisation reported!")
        //
        XCTAssertEqual(gen.getGeneratedSpecial(index: 0), 0, "Incorrect special initialisation reported!")
        XCTAssertEqual(gen.getGeneratedSpecial(index: 1), 0, "Incorrect special initialisation reported!")
        //
        // an out of range index should report 0
        //
        XCTAssertEqual(gen.getGeneratedNumber(index:  3), 0, "Incorrect number initialisation reported!")
        XCTAssertEqual(gen.getGeneratedSpecial(index: 2), 0, "Incorrect special initialisation reported!")
        //
        // test upper limits set appropriately
        //
        XCTAssertEqual(gen.getPossibleMaximumNumber(),  3, "Incorrect maximum number limit reported!")
        XCTAssertEqual(gen.getPossibleMaximumSpecial(), 0, "Incorrect maximum special limit reported!")
        return
    }
    
    func testGeneratorGenerate() {
        let gen: Generator = Generator(number: 3, maxNumber: 3)
        gen.generateNewLotteryNumbers()
        //
        // check all within acceptable range
        //
        XCTAssertTrue(((1..<4) ~= gen.getGeneratedNumber(index: 0)), "Generated number is out of range!")
        XCTAssertTrue(((1..<4) ~= gen.getGeneratedNumber(index: 1)), "Generated number is out of range!")
        XCTAssertTrue(((1..<4) ~= gen.getGeneratedNumber(index: 2)), "Generated number is out of range!")
        //
        // don't forget the specials
        //
        XCTAssertTrue(((1..<3) ~= gen.getGeneratedSpecial(index: 0)), "Generated number is out of range!")
        XCTAssertEqual(gen.getGeneratedSpecial(index: 1), 0, "Incorrect special initialisation reported!")
        return
    }
    
    //----------------------------------------------------------------------------
    // Struct: Content
    //----------------------------------------------------------------------------
    func testContentConstructor() {
        let con: LabelContent = LabelContent(displayNumber: 4, displayType: numberDisplayType.Number)
        XCTAssertEqual(con.displayNumber,                      4, "Incorrect displayNumber initialisation reported!")
        XCTAssertEqual(con.displayType, numberDisplayType.Number, "Incorrect displayType initialisation reported!")
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: LotteryDisplay (contains 'Content')
    //----------------------------------------------------------------------------
    func testLotteryDisplayConstructor_1() {
        let ldg: LotteryDisplay = LotteryDisplay()
        XCTAssertEqual(ldg.ident.hashValue, lotteryIdent.Undefined.rawValue, "Incorrect ident default initialisation value reported!")
        XCTAssertEqual(ldg.numbers.count,                                 0, "Incorrect initial number array size reported!")
        XCTAssertEqual(ldg.specials.count,                                0, "Incorrect initial specials array size reported!")
        XCTAssertEqual(ldg.bonus,                                     false, "Incorrect initial bonus flag reported!")
        XCTAssertEqual(ldg.active,                                    false, "Incorrect initial active flag reported!")
        return
    }

    func testLotteryDisplayConstructor_2() {
        let ldg: LotteryDisplay = LotteryDisplay(ident: lotteryIdent.Lotto, numbers: 5, specials: 2, bonus: true, active: true)
        XCTAssertEqual(ldg.ident.hashValue, lotteryIdent.Lotto.rawValue, "Incorrect ident default initialisation value reported!")
        XCTAssertEqual(ldg.numbers.count,                             5, "Incorrect initial number array size reported!")
        XCTAssertEqual(ldg.specials.count,                            2, "Incorrect initial specials array size reported!")
        XCTAssertEqual(ldg.bonus,                                  true, "Incorrect initial bonus flag reported!")
        XCTAssertEqual(ldg.active,                                 true, "Incorrect initial active flag reported!")
        //
        ldg.populateNumberArray(numbers: [1,4,7,8,12])
        //
        XCTAssertEqual(ldg.numbers[0].displayNumber,   1, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[1].displayNumber,   4, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[2].displayNumber,   7, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[3].displayNumber,   8, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[4].displayNumber,  12, "Incorrect number reported for array position!")
        //
        ldg.populateSpecialArray(specials: [2,14])
        //
        XCTAssertEqual(ldg.specials[0].displayNumber,  2, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[1].displayNumber, 14, "Incorrect special reported for array position!")
        return
    }
    
    func testLotteryDisplayClearFunctions() {
        let ldg: LotteryDisplay = LotteryDisplay(ident: lotteryIdent.Lotto, numbers: 5, specials: 2, bonus: true, active: true)
        XCTAssertEqual(ldg.ident, lotteryIdent.Lotto, "Incorrect ident default initialisation value reported!")
        XCTAssertEqual(ldg.numbers.count,          5, "Incorrect initial number array size reported!")
        XCTAssertEqual(ldg.specials.count,         2, "Incorrect initial specials array size reported!")
        XCTAssertEqual(ldg.bonuses.count,          1, "Incorrect initial bonuses array size reported!")
        XCTAssertEqual(ldg.active,              true, "Incorrect initial active flag reported!")
        //
        XCTAssertEqual(ldg.numbers[0].displayNumber,   1, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[1].displayNumber,   4, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[2].displayNumber,   7, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[3].displayNumber,   8, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[4].displayNumber,  12, "Incorrect number reported for array position!")
        //
        XCTAssertEqual(ldg.specials[0].displayNumber,  2, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[1].displayNumber, 14, "Incorrect special reported for array position!")
        //
        XCTAssertEqual(ldg.bonuses[0].displayNumber,  43, "Incorrect bonus reported for array position!")
        //
        // once set correctly now test the clear functions
        //
        ldg.clearNumbers()
        //
        XCTAssertEqual(ldg.numbers[0].displayNumber, 0, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[1].displayNumber, 0, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[2].displayNumber, 0, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[3].displayNumber, 0, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[4].displayNumber, 0, "Incorrect number reported for array position!")
        //
        ldg.clearSpecials()
        XCTAssertEqual(ldg.specials[0].displayNumber, 0, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[1].displayNumber, 0, "Incorrect special reported for array position!")
        //
        ldg.clearBonuses()
        XCTAssertEqual(ldg.bonuses[0].displayNumber,  0, "Incorrect bonus reported for array position!")
        return
    }
    
    func testLotteryDisplayPopulateFunctions() {
        let ldg: LotteryDisplay = LotteryDisplay(ident: lotteryIdent.Lotto, numbers: 6, specials: [2, 14, 33], bonus: [43, 50], active: true)
        XCTAssertEqual(ldg.ident, lotteryIdent.Lotto, "Incorrect ident default initialisation value reported!")
        XCTAssertEqual(ldg.numbers.count,              6, "Incorrect initial number array size reported!")
        XCTAssertEqual(ldg.specials.count,             3, "Incorrect initial specials array size reported!")
        XCTAssertEqual(ldg.bonuses.count,              2, "Incorrect initial bonuses array size reported!")
        XCTAssertEqual(ldg.active,                  true, "Incorrect initial active flag reported!")
        //
        XCTAssertEqual(ldg.numbers[0].displayNumber,   1, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[1].displayNumber,   4, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[2].displayNumber,   7, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[3].displayNumber,   8, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[4].displayNumber,  12, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[5].displayNumber,  34, "Incorrect number reported for array position!")
        //
        XCTAssertEqual(ldg.specials[0].displayNumber,  2, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[1].displayNumber, 14, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[2].displayNumber, 33, "Incorrect special reported for array position!")
        //
        XCTAssertEqual(ldg.bonuses[0].displayNumber,  43, "Incorrect bonus reported for array position!")
        XCTAssertEqual(ldg.bonuses[1].displayNumber,  50, "Incorrect bonus reported for array position!")
        //
        // once set correctly now test the populate functions
        //
        ldg.populateNumbers(numbers: [2, 3, 6, 9, 55, 60])
        XCTAssertEqual(ldg.numbers[0].displayNumber,  2, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[1].displayNumber,  3, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[2].displayNumber,  6, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[3].displayNumber,  9, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[4].displayNumber, 55, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[5].displayNumber, 60, "Incorrect number reported for array position!")
        //
        ldg.populateSpecials(specials: [1, 3, 11])
        XCTAssertEqual(ldg.specials[0].displayNumber,  1, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[1].displayNumber,  3, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[2].displayNumber, 11, "Incorrect special reported for array position!")
        //
        ldg.populateBonuses(bonuses: [1, 9])
        XCTAssertEqual(ldg.bonuses[0].displayNumber, 1, "Incorrect bonus reported for array position!")
        XCTAssertEqual(ldg.bonuses[1].displayNumber, 9, "Incorrect bonus reported for array position!")
        //
        // test out of range functions (leave results as set if wrong size array sent to replace)
        //
        ldg.populateNumbers(numbers: [1, 4, 7, 25, 31, 54, 71])
        XCTAssertEqual(ldg.numbers[0].displayNumber,  2, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[1].displayNumber,  3, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[2].displayNumber,  6, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[3].displayNumber,  9, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[4].displayNumber, 55, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[5].displayNumber, 60, "Incorrect number reported for array position!")
        //
        ldg.populateNumbers(numbers: [1, 4, 7, 25])
        XCTAssertEqual(ldg.numbers[0].displayNumber,  2, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[1].displayNumber,  3, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[2].displayNumber,  6, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[3].displayNumber,  9, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[4].displayNumber, 55, "Incorrect number reported for array position!")
        XCTAssertEqual(ldg.numbers[5].displayNumber, 60, "Incorrect number reported for array position!")
        //
        ldg.populateSpecials(specials: [5, 12, 19, 34])
        XCTAssertEqual(ldg.specials[0].displayNumber,  1, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[1].displayNumber,  3, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[2].displayNumber, 11, "Incorrect special reported for array position!")
        //
        ldg.populateSpecials(specials: [5, 12])
        XCTAssertEqual(ldg.specials[0].displayNumber,  1, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[1].displayNumber,  3, "Incorrect special reported for array position!")
        XCTAssertEqual(ldg.specials[2].displayNumber, 11, "Incorrect special reported for array position!")
        //
        ldg.populateBonuses(bonuses: [6, 33, 35])
        XCTAssertEqual(ldg.bonuses[0].displayNumber, 1, "Incorrect bonus reported for array position!")
        XCTAssertEqual(ldg.bonuses[1].displayNumber, 9, "Incorrect bonus reported for array position!")
        //
        ldg.populateBonuses(bonuses: [6])
        XCTAssertEqual(ldg.bonuses[0].displayNumber, 1, "Incorrect bonus reported for array position!")
        XCTAssertEqual(ldg.bonuses[1].displayNumber, 9, "Incorrect bonus reported for array position!")
        return
    }
    
}
