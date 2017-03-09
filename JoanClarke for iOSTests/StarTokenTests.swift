//
//  StarTokenTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 3/8/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class StarTokenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatchSequentialDecreasing() {
        let token = StarToken()
        let candidate = Candidate(word: "AS")
        let claim2 = Claim(maxLength: 2, startIndex: 0, count: 2)
        let claim1 = Claim(maxLength: 2, startIndex: 0, count: 1)
        let claim0 = Claim(maxLength: 2, startIndex: 0, count: 0)
        
        var result = token.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token._previousClaim, claim2)

        result = token.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token._previousClaim, claim1)

        result = token.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token._previousClaim, claim0)

        result = token.MatchSequential(candidate)
        XCTAssert(!result)
}
    
    func testMatchSequentialMiddle() {
        let token = StarToken()
        let candidate = Candidate(word: "APPLE")
        let claim = Claim(maxLength: 5, startIndex: 0, count: 1)
        candidate.Stake(claim)
        let claim2 = Claim(maxLength: 5, startIndex: 4, count: 1)
        candidate.Stake(claim2)
        
        let result = token.MatchAny(candidate)
        XCTAssert(result)
        
        XCTAssertEqual(token._previousClaim!.ClaimedText(candidate.Word), "PPL")
    }
    
    func testMatchAnySuccess() {
        let token = StarToken()
        let candidate = Candidate(word: "APPLE")
        
        let claim = Claim(maxLength: 5, startIndex: 0, count: 5)
        let result = token.MatchAny(candidate)
        XCTAssert(result)
        XCTAssertEqual(token._previousClaim, claim)
    }
    
    func testMatchAnyRest() {
        let token = StarToken()
        let candidate = Candidate(word: "APPLE")
        let claim = Claim(maxLength: 5, startIndex: 1, count: 3)
        candidate.Stake(claim)
        
        let result = token.MatchAny(candidate)
        XCTAssert(result)
        
        XCTAssertEqual(token._previousClaim!.ClaimedText(candidate.Word), "AE")
    }
    
}
