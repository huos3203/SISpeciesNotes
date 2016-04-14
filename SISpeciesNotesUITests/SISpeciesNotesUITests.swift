//
//  SISpeciesNotesUITests.swift
//  SISpeciesNotesUITests
//
//  Created by huoshuguang on 16/4/14.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

//[WWDC15 Session笔记 - Xcode 7 UI 测试初窥](https://onevcat.com/2015/09/ui-testing/)
/*
    第一步：录制
    第二步：断言
 
 */
import XCTest

class SISpeciesNotesUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        //XCUIApplication 是 UIApplication 在测试进程中的代理 (proxy)，我们可以在 UI 测试中通过这个类型和应用本身进行一些交互，比如开始或者终止一个 app

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
