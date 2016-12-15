//
//  LetterSetTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/14/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class LetterSetTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLetters() {
        let set = LetterSet(str: "World", exclusive: false)
        XCTAssert(set.Letters?.characters.count == 5)
    }

    func testIsInSet() {
        let set = LetterSet(str: "World", exclusive: false)
        var ch : Character = "r"
        XCTAssert(set.IsInSet(ch))
        ch = "w"
        XCTAssert(set.IsInSet(ch))
        ch = "z"
        XCTAssert(!set.IsInSet(ch))
    }
    
    func testAreAllInSet() {
        let set = LetterSet(str: "WORLD", exclusive: false)
        XCTAssert(set.AreAllInSet("oD"))
        XCTAssert(!set.AreAllInSet("wz"))
    }
}

class ExhaustibleLetterSetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReserveAndReturn() {
        let set = ExhaustibleLetterSet(str: "World")
        let ch : Character = "r"
        XCTAssert(set.IsInSet(ch))

        set.Reserve("r")
        XCTAssert(!set.IsInSet(ch))
        set.Return("r")
        XCTAssert(set.IsInSet(ch))
    }

    
    func testAreAllInSet() {
        let set = ExhaustibleLetterSet(str: "HELLO")
        XCTAssert(set.AreAllInSet("LL"))
        XCTAssert(!set.AreAllInSet("OO"))
    }
}

