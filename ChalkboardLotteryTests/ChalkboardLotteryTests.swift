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
    // Class: Generator
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
        //
        // generate the lottery numbers
        //
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
        XCTAssertTrue(((1..<3) ~= gen.getGeneratedSpecial(index: 1)), "Generated number is out of range!")
        return
    }
    
//    //----------------------------------------------------------------------------
//    // Struct: Numbers
//    //----------------------------------------------------------------------------
//    func testNumbersStruct() {
//        let nr: Numbers = Numbers(size: 5, limits: NumberRange(upperLimit: 65, lowerLimit: 3))
//        XCTAssertEqual(nr.value.count,  5, "Incorrect number of entries reported!")
//        XCTAssertEqual(nr.range.upper, 65, "Incorrect upper limit reported!")
//        XCTAssertEqual(nr.range.lower,  3, "Incorrect upper limit reported!")
//        return
//    }
//    
//    //----------------------------------------------------------------------------
//    // Class: Lottery
//    //----------------------------------------------------------------------------
//    func testLotteryClass() {
//        let ltry: Lottery = Lottery(nbrs: 5, nbrRange: NumberRange(upperLimit: 5, lowerLimit: 1), spcs: 3, spcRange: NumberRange(upperLimit: 3, lowerLimit: 1))
//        XCTAssertEqual(ltry.getNumber(position: 0), 1, "Incorrect value at 5th position!")
//        XCTAssertEqual(ltry.getNumber(position: 1), 2, "Incorrect value at 4th position!")
//        XCTAssertEqual(ltry.getNumber(position: 2), 3, "Incorrect value at 3rd position!")
//        XCTAssertEqual(ltry.getNumber(position: 3), 4, "Incorrect value at 2nd position!")
//        XCTAssertEqual(ltry.getNumber(position: 4), 5, "Incorrect value at 1st position!")
//        return
//    }

}
