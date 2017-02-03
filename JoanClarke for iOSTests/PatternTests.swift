//
//  PatternTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 2/2/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class PatternTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUnknownToken() {
        do
        {
            let _ = try Pattern(raw: "!")
            XCTFail("Should have thrown exception")
        }
        catch PatternError.unrecognizedToken(let token)
        {
            XCTAssertEqual(token, "!")
        }
        catch
        {
            XCTFail("No other exceptions")
        }
    }
    
    func testMatchLetters() {
        let word = "APPLE"
        do
        {
            let pattern = try Pattern(raw: "apple")
            XCTAssert(try pattern.Match(word: word))
        }
        catch
        {
            XCTFail("Should not throw")
        }
    }
    
    func testMatchDots() {
        let word = "APPLE"
        do
        {
            let pattern = try Pattern(raw: "a..l.")
            XCTAssert(try pattern.Match(word: word))
        }
        catch
        {
            XCTFail("Should not throw")
        }
    }
    
    func testMatchLettersReuse() {
        let word = "APPLE"
        let word2 = "APPLESAUCE"
        let word3 = "APPLES"
        do
        {
            let pattern = try Pattern(raw: "apples")
            XCTAssert(!(try pattern.Match(word: word)))
            XCTAssert(!(try pattern.Match(word: word2)))
            XCTAssert(try pattern.Match(word: word3))
        }
        catch
        {
            XCTFail("Should not throw")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
