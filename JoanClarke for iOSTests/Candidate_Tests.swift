//
//  Candidate_Tests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/5/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class Candidate_Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetters() {
        let candidate = Candidate(word: "Hello")
        XCTAssertEqual(candidate.Word, "Hello")
        XCTAssertNil(candidate.PreviousLink)
        
    }
    
    func testStake() {
        let candidate = Candidate(word: "Hello")
        
        candidate.Stake(Claim(maxLength: 5, startIndex: 0, count: 1))
        XCTAssertEqual(candidate.GetAllRemaining(), Claim(maxLength: 5, startIndex: 1, count: 4))
    }

    func testFree() {
        let candidate = Candidate(word: "Hello")
        candidate.Stake(Claim(maxLength: 5, startIndex: 0, count: 2))
        candidate.Free(Claim(maxLength: 5, startIndex: 1, count: 1))
        XCTAssertEqual(candidate.GetAllRemaining(), Claim(maxLength: 5, startIndex: 1, count: 4))
    }
    
    func testGetNextUnused() {
        let candidate = Candidate(word: "Hello")
        XCTAssertEqual(candidate.GetNextUnused(2), Claim(maxLength: 5, startIndex: 0, count: 2))
        
        let claimPrevious = Claim(maxLength: 5, startIndex: 1, count: 1)
        XCTAssertEqual(candidate.GetNextUnused(claimPrevious), Claim(maxLength: 5, startIndex: 2, count: 1))

        XCTAssertEqual(candidate.GetNextUnused(), Claim(maxLength: 5, startIndex: 0, count: 1))
    }
    
    func testFind() {
        let candidate = Candidate(word: "Hello")
        var charToTest : Character = "e"
        XCTAssertEqual(candidate.Find(charToTest), Claim(maxLength: 5, startIndex: 1, count: 1))
        
        charToTest = "z"
        XCTAssertTrue(candidate.Find(charToTest).IsEmpty())
        
        charToTest = "L"
        let prev = Claim(maxLength: 5, startIndex: 2, count: 1)
        XCTAssertEqual(candidate.Find(prev, ch: charToTest), Claim(maxLength: 5, startIndex: 3, count: 1))
    }

}
