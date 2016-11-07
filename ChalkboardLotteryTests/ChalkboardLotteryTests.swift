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
    // Struct: NumberRange
    //----------------------------------------------------------------------------
    func testNumberRangeStruct() {
        let nr: NumberRange = NumberRange(upperLimit: 10, lowerLimit: 4)
        XCTAssertEqual(nr.upper, 10, "Incorrect upper limit reported!")
        XCTAssertEqual(nr.lower,  4, "Incorrect lower limit reported!")
        return
    }
    
    //----------------------------------------------------------------------------
    // Struct: Numbers
    //----------------------------------------------------------------------------
    func testNumbersStruct() {
        let nr: Numbers = Numbers(size: 5, limits: NumberRange(upperLimit: 65, lowerLimit: 3))
        XCTAssertEqual(nr.value.count,  5, "Incorrect number of entries reported!")
        XCTAssertEqual(nr.range.upper, 65, "Incorrect upper limit reported!")
        XCTAssertEqual(nr.range.lower,  3, "Incorrect upper limit reported!")
        return
    }
    
    //----------------------------------------------------------------------------
    // Class: Lottery
    //----------------------------------------------------------------------------
    func testLotteryClass() {
        let ltry: Lottery = Lottery(nbrs: 5, nbrRange: NumberRange(upperLimit: 5, lowerLimit: 1), spcs: 3, spcRange: NumberRange(upperLimit: 3, lowerLimit: 1))
        XCTAssertEqual(ltry.getNumber(position: 0), 1, "Incorrect value at 5th position!")
        XCTAssertEqual(ltry.getNumber(position: 1), 2, "Incorrect value at 4th position!")
        XCTAssertEqual(ltry.getNumber(position: 2), 3, "Incorrect value at 3rd position!")
        XCTAssertEqual(ltry.getNumber(position: 3), 4, "Incorrect value at 2nd position!")
        XCTAssertEqual(ltry.getNumber(position: 4), 5, "Incorrect value at 1st position!")
        return
    }

}
