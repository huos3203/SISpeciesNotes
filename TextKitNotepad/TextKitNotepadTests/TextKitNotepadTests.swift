//
//  TextKitNotepadTests.swift
//  TextKitNotepadTests
//
//  Created by pengyucheng on 16/5/4.
//  Copyright © 2016年 recomend. All rights reserved.
//

import XCTest
@testable import TextKitNotepad

class TextKitNotepadTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let noteModel = NoteModel.init(newText: "Use XCTAssert and related functions to verify your\n tests produce the correct results")
        print(noteModel.title)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}