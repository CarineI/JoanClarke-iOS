//
//  AnagramTokenTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 4/6/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class AnagramTokenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatchWhole() {
       
       do {
            let token = try AnagramToken(pattern: "PLAEP")
            let candidate = Candidate(word: "APPLE")
            
            let result = try token.MatchSequential(candidate)
            XCTAssert(result)
            XCTAssert(candidate.GetAllRemaining().IsEmpty())
        }
        catch
        {
            XCTFail("No exceptions expected")
        }
    }
    
    func testMatchPortion() {
        
        do {
            let token = try AnagramToken(pattern: "PPA")
            let candidate = Candidate(word: "APPLE")
            
            let claim = Claim(maxLength: 5, startIndex: 3, count: 2)
            let result = try token.MatchSequential(candidate)
            XCTAssert(result)
            XCTAssertEqual(candidate.GetAllRemaining(), claim)
        }
        catch
        {
            XCTFail("No exceptions expected")
        }
    }
}
