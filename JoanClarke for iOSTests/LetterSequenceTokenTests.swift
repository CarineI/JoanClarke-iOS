//
//  LetterSequenceTokenTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 11/22/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class LetterSequenceTokenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatchSequentialSuccess() {
        let token = LetterSequenceToken(letters: "ap")
        let candidate = Candidate(word: "APPLE")
        let claim = Claim(maxLength: 5, startIndex: 0, count: 2)
        
        do
        {
            let result = try token.MatchSequential(candidate)
            XCTAssert(result)
            
            XCTAssertEqual(token._previousClaim, claim)
        }
        catch
        {
            XCTFail("Token should not have thrown")
        }
    }
    
    func testMatchSequentialFails() {
        let token = LetterSequenceToken(letters: "pp")
        let candidate = Candidate(word: "APPLE")
        
        do
        {
            let result = try token.MatchSequential(candidate)
            XCTAssert(!result)
            
            XCTAssertNil(token._previousClaim)
        }
        catch
        {
            XCTFail("Token should not have thrown")
        }
    }
    
    func testMergeWith() {
        let tokenA = LetterSequenceToken(letters: "ab")
        let tokenB = LetterToken(letter: "c")
        
        let tokenC = tokenA.MergeWith(tokenB, inAnagram: false)
        
        XCTAssert(tokenC is LetterSequenceToken)
        XCTAssertEqual((tokenC as! LetterSequenceToken).Letters, "ABC")
        
        // Merge with inside anagrams is not supported
        XCTAssertNil(tokenA.MergeWith(tokenB, inAnagram: true))
        
    }}
