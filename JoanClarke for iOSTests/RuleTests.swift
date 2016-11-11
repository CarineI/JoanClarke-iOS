//
//  Rule.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 11/2/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class RuleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExpand() {
        XCTAssertEqual("abc", Rule.Expand("abc"))
        XCTAssertEqual("abcd", Rule.Expand("a-d"))
        XCTAssertEqual("abc", Rule.Expand("a,b,c"))
        XCTAssertEqual("abc123", Rule.Expand("a-c,1-3"))
        
    }

    func testInit() {
        do
        {
            var r = try Rule(raw: ".={a}")
            XCTAssertEqual(r.Letters!.Letters!, "a")

            r = try Rule(raw: "*>=3")
            XCTAssertEqual(r.MinLength!, 3)
            XCTAssertEqual(r.MaxLength, nil)

            r = try Rule(raw: "*==3")
            XCTAssertEqual(r.MinLength!, 3)
            XCTAssertEqual(r.MaxLength!, 3)
            r = try Rule(raw: "*<=3")
            XCTAssertEqual(r.MaxLength!, 3)
            XCTAssertEqual(r.MinLength, nil)
            r = try Rule(raw: "*=<3")
            XCTAssertEqual(r.MaxLength!, 2)
            XCTAssertEqual(r.MinLength, nil)
            r = try Rule(raw: "*=>3")
            XCTAssertEqual(r.MinLength!, 4)
            XCTAssertEqual(r.MaxLength, nil)
            
            r = try Rule(raw: "1=.")
            XCTAssert(r.IsDotRedefine)
            r = try Rule(raw: ".=0")
            XCTAssert(r.IsCryptoRedefine)
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
    }
    
    func testIsUnique() {
        do
        {
            var r = try Rule(raw: ".=~")
            XCTAssert(!r.IsUnique(true))
            r = try Rule(raw: "*==3")
            XCTAssert(!r.IsUnique(false))
            r = try Rule(raw: "1=^")
            XCTAssert(r.IsUnique(false))
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
    }
    
    func testIsInSet() {
        do
        {
            var r = try Rule(raw: ".=~")
            XCTAssert(r.IsInSet("a"))
            r = try Rule(raw: "*={abc}")
            XCTAssert(r.IsInSet("a"))
            XCTAssert(!r.IsInSet("z"))
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
    }
    
    func testAreAllInSet() {
        do
        {
            var r = try Rule(raw: ".=~")
            XCTAssert(r.AreAllInSet("az"))
            r = try Rule(raw: "*={abc}")
            XCTAssert(r.AreAllInSet("ac"))
            XCTAssert(!r.AreAllInSet("az"))
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
    }

    func testIsValidLength() {
        do
        {
            var r = try Rule(raw: ".={abc}")
            XCTAssert(r.IsValidLength(12))
            r = try Rule(raw: "*>=5")
            XCTAssert(r.IsValidLength(12))
            XCTAssert(!r.IsValidLength(4))
            r = try Rule(raw: "*==5")
            XCTAssert(r.IsValidLength(5))
            XCTAssert(!r.IsValidLength(4))
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
    }
    
    func testGetMinMaxLength() {
        do
        {
            var r = try Rule(raw: ".=~")
            var minLength : Int = 0
            var maxLength : Int = 0
            r.GetMinMaxLength(&minLength, max: &maxLength)
            XCTAssertEqual(minLength, 0)
            XCTAssertEqual(maxLength, 1000)
            
            r = try Rule(raw: "*>=5")
            r.GetMinMaxLength(&minLength, max: &maxLength)
            XCTAssertEqual(minLength, 5)
            XCTAssertEqual(maxLength, 1000)
            
            r = try Rule(raw: "*=<5")
            r.GetMinMaxLength(&minLength, max: &maxLength)
            XCTAssertEqual(minLength, 0)
            XCTAssertEqual(maxLength, 4)
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
    }
    
    func testMerge() {
        do
        {
            var r = try Rule(raw: "*=>5")
            var s = try Rule(raw: "*<=10")
            var t = Rule(r: r, s: s)
            var minLength : Int = 0
            var maxLength : Int = 0
            t.GetMinMaxLength(&minLength, max: &maxLength)
            XCTAssertEqual(minLength, 6)
            XCTAssertEqual(maxLength, 10)
            
            r = try Rule(raw: "1=~")
            s = try Rule(raw: "1={abc}")
            t = Rule(r: r, s: s)
            XCTAssert(!t.IsUnique())
            XCTAssert(t.AreAllInSet("cba"))
            XCTAssert(!t.IsInSet("d"))

            // absurd case :)  If the rule merge gets smarter, and disallows this, test will fail
            r = try Rule(raw: "*=0")
            s = try Rule(raw: "*=.")
            t = Rule(r: r, s: s)
            XCTAssert(t.IsCryptoRedefine)
            XCTAssert(t.IsDotRedefine)
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
    }

    func testObeysRules() {
        do
        {
            let r = try Rule(raw: "*=>5")
            let s = try Rule(raw: "*<=10")
            let t = try Rule(raw: "*={unites}")
            var u = Rule(r: r, s: s)
            u = Rule(r: u, s: t)
            
            var candidate = Candidate(word: "unittest")
            var claim = Claim(maxLength: 8, startIndex: 0, count: 8)
            XCTAssert(u.ObeysRules(claim, candidate: candidate))

            candidate = Candidate(word: "unittestx")  // fails because of x in letterset
            claim = Claim(maxLength: 9, startIndex: 0, count: 9)
            XCTAssert(!u.ObeysRules(claim, candidate: candidate))
    
            candidate = Candidate(word: "unittesttest")  // fails because of length
            claim = Claim(maxLength: 12, startIndex: 0, count: 12)
            XCTAssert(!u.ObeysRules(claim, candidate: candidate))
        }
        catch
        {
            XCTFail("Rule constructor should not have thrown")
        }
        
    }
}
