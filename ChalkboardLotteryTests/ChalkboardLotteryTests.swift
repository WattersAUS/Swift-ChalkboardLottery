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
        let con: Content = Content(displayNumber: 4, displayType: numberDisplayType.Number)
        XCTAssertEqual(con.displayNumber,                      4, "Incorrect displayNumber initialisation reported!")
        XCTAssertEqual(con.displayType, numberDisplayType.Number, "Incorrect displayType initialisation reported!")
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: LotteryDisplay (contains 'Content'
    //----------------------------------------------------------------------------
    func testLotteryDisplayConstructor_1() {
        let ldg: LotteryDisplay = LotteryDisplay()
        XCTAssertEqual(ldg.ident, lotteryIdent.Undefined, "Incorrect ident default initialisation value reported!")
        XCTAssertEqual(ldg.numbers.count,              0, "Incorrect initial number array size reported!")
        XCTAssertEqual(ldg.specials.count,             0, "Incorrect initial specials array size reported!")
        XCTAssertEqual(ldg.bonuses.count,              0, "Incorrect initial bonuses array size reported!")
        XCTAssertEqual(ldg.active,                 false, "Incorrect initial active flag reported!")
        return
    }

    func testLotteryDisplayConstructor_2() {
        let ldg: LotteryDisplay = LotteryDisplay(ident: lotteryIdent.Lotto, numbers: [1, 4, 7, 8, 12], specials: [2, 14], bonus: [43], active: true)
        XCTAssertEqual(ldg.ident, lotteryIdent.Lotto, "Incorrect ident default initialisation value reported!")
        XCTAssertEqual(ldg.numbers.count,              5, "Incorrect initial number array size reported!")
        XCTAssertEqual(ldg.specials.count,             2, "Incorrect initial specials array size reported!")
        XCTAssertEqual(ldg.bonuses.count,              1, "Incorrect initial bonuses array size reported!")
        XCTAssertEqual(ldg.active,                  true, "Incorrect initial active flag reported!")
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
        return
    }
    
}
