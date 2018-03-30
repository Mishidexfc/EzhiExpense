//
//  Expense_TestTests.swift
//  Expense_TestTests
//
//  Created by Jue Wang on 2018/2/26.
//  Copyright © 2018年 Jue Wang. All rights reserved.
//

import XCTest
@testable import Expense_Test

class Expense_TestTests: XCTestCase {
    var vc : InitialViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(withIdentifier: "initialVC") as! InitialViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results
        let a = 123
        XCTAssert(a == 123)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
