//
//  PercentageCalculator.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/11.
//  Copyright © 2016年 益行人. All rights reserved.
//

//[原文](http://www.jianshu.com/p/b0525df8e68f)
//
import XCTest
@testable import SISpeciesNotes
//http://www.cocoachina.com/ios/20151125/14415.html
//新建test target重置配置：http://stackoverflow.com/questions/32008403/no-such-module-when-using-testable-in-xcode-unit-tests
//xcode特性：http://www.tuicool.com/articles/rMzMjaa

//“No such module” when using @testable in Xcode Unit tests
//解决办法：是应为SISpeciesnotesTests的 build setting -> build active architecture Only ->debug选项设置为YES

class PercentageCalculator: XCTestCase {
    var vc:PercentageCalculatorViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//    var p = PercentageCalculatorViewController()
        
        let storyboard = UIStoryboard(name:"Main",bundle: NSBundle.mainBundle())
        vc = storyboard.instantiateInitialViewController() as! PercentageCalculatorViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testPercentageCalculator()
    {
        //测试
       var sender = 50
       let result = vc.updateResult(&sender, num: 50)
       XCTAssert(result == 25)
    }
    
    //    我已经在storyboard中已经建好了这些lables，并且在视图加载的时候就已经进行了初始化任务，但是在单元测试部分loadView()方法永远都不会触发因此这些值都是空值。一个可能的解决方法是我们自己调用vc.loadView()，但是这种做法官方文档里面并不提倡，因为这种做法可能导致内存泄漏（当视图进行了多次加载的时候）。
    
//    正确的解决方法是，访问vc的view属性。该做法会触发所有需要的方法，不仅仅只有loadView()。
    
    func testLabelValuesShowedProperly() {
        
//        注意到我们使用下划线_来代表一个常量名。这是因为我们并不真正需要这个常量也永远不会使用这个常量。它只是用来告诉编译器”假装访问并触发视图的所有方法。“
        let _ = vc.view
        
        vc.updateLabels(Float(80.0), Float(50.0), Float(40.0))
        
        // The labels should now display 80, 50 and 40
        XCTAssert(vc.ibNumberLabel.text == "80.0", "numberLabel doesn't show the right text")
        XCTAssert(vc.ibPercentageLabel.text == "50.0%", "percentageLabel doesn't show the right text")
        XCTAssert(vc.ibResultLabel.text == "40.0", "resultLabel doesn't show the right text")
    }
}
