//
//  CryptoTokenTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 5/11/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class CryptoTokenTests: XCTestCase {
    
    func testMatchSequentialSuccess_SingleRefCount() {
        let token = CryptoToken(codedCharacter: "1")
        let candidate = Candidate(word: "APPLE")
        let claim = Claim(maxLength: 5, startIndex: 0, count: 1)
        
        let result = token.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token._previousClaim, claim)
        token.Pop(candidate)
    }
    
    func testMatchSequentialDuplicatesSuccess() {
        let token1 = CryptoToken(codedCharacter: "2")
        let token2 = CryptoToken(codedCharacter: "2")
        let claim1 = Claim(maxLength: 2, startIndex: 0, count: 1)
        let claim2 = Claim(maxLength: 2, startIndex: 1, count: 1)
        let candidate = Candidate(word: "AA")

        var result = token1.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token1._previousClaim, claim1)
        result = token2.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token2._previousClaim, claim2)
        token1.Pop(candidate)
        token2.Pop(candidate)
    }

    func testMatchSequentialDuplicatesFailure() {
        let token1 = CryptoToken(codedCharacter: "2")
        let token2 = CryptoToken(codedCharacter: "2")
        let claim1 = Claim(maxLength: 2, startIndex: 0, count: 1)
        let candidate = Candidate(word: "AB")
        
        var result = token1.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token1._previousClaim, claim1)
        result = token2.MatchSequential(candidate)
        XCTAssertFalse(result)
        token1.Pop(candidate)
        token2.Pop(candidate)
    }
    
    func testMatchSequentialDifferentSuccess() {
        let token1 = CryptoToken(codedCharacter: "1")
        let token2 = CryptoToken(codedCharacter: "2")
        let claim1 = Claim(maxLength: 2, startIndex: 0, count: 1)
        let claim2 = Claim(maxLength: 2, startIndex: 1, count: 1)
        let candidate = Candidate(word: "AB")
        
        var result = token1.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token1._previousClaim, claim1)
        result = token2.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token2._previousClaim, claim2)
        token1.Pop(candidate)
        token2.Pop(candidate)
    }
    
    func testMatchSequentialDifferentFailure() {
        let token1 = CryptoToken(codedCharacter: "1")
        let token2 = CryptoToken(codedCharacter: "2")
        let claim1 = Claim(maxLength: 2, startIndex: 0, count: 1)
        let candidate = Candidate(word: "AA")
        
        var result = token1.MatchSequential(candidate)
        XCTAssert(result)
        XCTAssertEqual(token1._previousClaim, claim1)
        result = token2.MatchSequential(candidate)
        XCTAssertFalse(result)
        token1.Pop(candidate)
        token2.Pop(candidate)
    }
    
    func testMatchAnySuccess_() {
        let token1 = CryptoToken(codedCharacter: "1")
        let token2 = CryptoToken(codedCharacter: "1")
        let candidate = Candidate(word: "APPLE")
        let claim1 = Claim(maxLength: 5, startIndex: 0, count: 1)
        let claim2 = Claim(maxLength: 5, startIndex: 1, count: 1)
        let claim3 = Claim(maxLength: 5, startIndex: 2, count: 1)
        
        var result = token1.MatchAny(candidate)
        XCTAssert(result)
        XCTAssertEqual(token1._previousClaim, claim1)
        
        result = token2.MatchAny(candidate)
        XCTAssertFalse(result)
        token2.Pop(candidate)
        
        result = token1.MatchAny(candidate)
        XCTAssert(result)
        XCTAssertEqual(token1._previousClaim, claim2)
        
        result = token2.MatchAny(candidate)
        XCTAssert(result)
        XCTAssertEqual(token2._previousClaim, claim3)
        
        token1.Pop(candidate)
        token2.Pop(candidate)
    }
    
    
}
