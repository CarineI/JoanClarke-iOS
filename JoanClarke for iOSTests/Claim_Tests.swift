//
//  JoanClarke_for_iOSTests.swift
//  JoanClarke for iOSTests
//
//  Created by Carine Iskander on 8/17/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class Claim_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClaimedText() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let mainClaim = Claim(maxLength: 11, startIndex: 1, count: 2)
        let str = mainClaim.ClaimedText("hello world")
        print(str)
        XCTAssert(str == "el")
    }
    
    func testNextUnclaimedCharacter() {
        var claim2 = Claim(maxLength: 5)
        claim2 = claim2.NextUnclaimedCharacter(1) // claims the first letter
        claim2 = claim2.NextUnclaimedCharacter(2) // claims the next 2 letters after the first letter
        print(claim2.ClaimedText("world"))
        XCTAssert(claim2.ClaimedText("world") == "or")
        
        claim2 = Claim(maxLength: 5)
        var claimPrev : Claim?
        claimPrev = claim2.NextUnclaimedCharacter(claimPrev)
        print(claimPrev!.ClaimedText("world"))
        XCTAssert(claimPrev!.ClaimedText("world") == "w")
        claimPrev = claim2.NextUnclaimedCharacter(claimPrev)
        print(claimPrev!.ClaimedText("world"))
        XCTAssert(claimPrev!.ClaimedText("world") == "o")
    }
    
    func testIsEmpty() {
        let claim = Claim(maxLength: 5)
        XCTAssert(claim.IsEmpty())
        
        let claim2 = Claim(maxLength: 11, startIndex: 1, count: 2)
        XCTAssert(!claim2.IsEmpty())
    }
    
    func testLength() {
        let claim = Claim(maxLength: 5)
        XCTAssertEqual(claim.Length(), 0)
        
        let claim2 = Claim(maxLength: 11, startIndex: 1, count: 2)
        XCTAssertEqual(claim2.Length(), 2)
    }
    
    func testAllUnclaimedCharactere() {
        let claim = Claim(maxLength: 5, startIndex: 1, count: 2)
        let claim2 = claim.AllUnclaimedCharacters()
        XCTAssertEqual(claim2.Length(), 3)
    }
    
    func testNextUnclaimedIndex() {
        let claim = Claim(maxLength: 5, startIndex: 1, count: 2)
        let claim2 = claim.AllUnclaimedCharacters()
        XCTAssertEqual(claim2.NextUnclaimedIndex(), 1)
        XCTAssertEqual(claim2.NextUnclaimedIndex(1), 2)
        XCTAssertEqual(claim2.NextUnclaimedIndex(2), -1)
    }
    
    func testFirstIndex() {
        let claim = Claim(maxLength: 5)
        let claim2 = Claim(maxLength: 5, startIndex: 1, count: 2)
        XCTAssertEqual(claim.FirstIndex(), -1)
        XCTAssertEqual(claim2.FirstIndex(), 1)
    }
    
    func testUnclaimLast() {
        let claim = Claim(maxLength: 5, startIndex: 1, count: 2)
        let claim2 = claim.UnclaimLast()
        XCTAssertEqual(claim2.Length(), 1)
    }
    
    func testDoClaimsOverlap() {
        let claim = Claim(maxLength: 5, startIndex: 1, count: 2)
        let claim2 = Claim(maxLength: 5, startIndex: 2, count: 2)
        let claim3 = Claim(maxLength: 5, startIndex: 3, count: 2)
        
        XCTAssert(claim.DoClaimsOverlap(claim2))
        XCTAssert(!claim.DoClaimsOverlap(claim3))
    }
    
    func testIsSubclaimOf() {
        let claim = Claim(maxLength: 5, startIndex: 1, count: 2)
        let claim2 = Claim(maxLength: 5, startIndex: 2, count: 1)
        let claim3 = Claim(maxLength: 5, startIndex: 2, count: 2)
        
        XCTAssert(claim2.IsSubclaimOf(claim))
        XCTAssert(!claim3.IsSubclaimOf(claim))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testCombineClaims() {
        
        let claim1 = Claim(maxLength: 5, startIndex: 1, count: 1)
        let claim2 = Claim(maxLength: 5, startIndex: 2, count: 1)
        
        let combined =  Claim.CombineClaims(claim1, b: claim2)
        XCTAssertEqual(combined, Claim(maxLength: 5, startIndex: 1, count: 2))
    }
    

    func testSeparateClaims() {
        
        let claim1 = Claim(maxLength: 5, startIndex: 1, count: 3)
        let claim2 = Claim(maxLength: 5, startIndex: 3, count: 1)
        
        let separated = Claim.SeparateClaims(claim1, b: claim2)
        XCTAssertEqual(separated, Claim(maxLength: 5, startIndex: 1, count: 2))
    }
}
