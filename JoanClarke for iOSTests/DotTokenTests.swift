//
//  DotTokenTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 1/11/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class DotTokenTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMatchSequentialSuccess() {
        let token = DotToken(tokenChar: ".")
        let candidate = Candidate(word: "APPLE")
        let claim = Claim(maxLength: 5, startIndex: 0, count: 1)
        
        let result = token.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token._previousClaim, claim)
    }
    
    func testMatchSequentialFails() {
        let token = DotToken(tokenChar: ".")
        let candidate = Candidate(word: "")
        
        let result = token.MatchSequential(candidate)
        XCTAssert(!result)
        XCTAssertNil(token._previousClaim)
    }
    
    func testMatchAnySuccess() {
        let token = DotToken(tokenChar: ".")
        let candidate = Candidate(word: "APPLE")
        
        let claim = Claim(maxLength: 5, startIndex: 0, count: 1)
        let result = token.MatchAny(candidate)
        XCTAssert(result)
        XCTAssertEqual(token._previousClaim, claim)

        let claim2 = Claim(maxLength: 5, startIndex: 1, count: 1)
        let result2 = token.MatchAny(candidate)
        XCTAssert(result2)
        XCTAssertEqual(token._previousClaim, claim2)
    }
    
    func testMatchAnyFails() {
        let token = DotToken(tokenChar: ".")
        let candidate = Candidate(word: "APPLE")
        let claim = Claim(maxLength: 5, startIndex: 0, count: 5)
        candidate.Stake(claim)
        
        let result = token.MatchAny(candidate)
        XCTAssert(!result)
        
        XCTAssertEqual(token._previousClaim, nil)
    }

}
