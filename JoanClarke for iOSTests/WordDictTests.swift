//
//  WordDictTests.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 12/14/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import XCTest
@testable import JoanClarke_for_iOS

class WordDictTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
            let stb = WordDict()
            stb.LoadFromBundle()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
