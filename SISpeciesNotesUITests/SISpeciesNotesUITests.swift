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
    
    /**
     
     UI Testing 和 Accessibility
     UI Accessibility 早在 iOS 3.0 就被引入了，用来辅助身体不便的人士使用 app。VoiceOver 是 Apple 的屏幕阅读技术，而 UI Accessibility 的基本原则就是对屏幕上的 UI 元素进行分类和标记。两者配合，通过阅读或者聆听这些元素，用户就可以在不接触屏幕的情况下通过声音来使用 app。
     
     Accessibility 的核心思想是对 UI 元素进行分类和标记 -- 将屏幕上的 UI 分类为像是按钮，文本框，cell 或者是静态文本 (也就是 label) 这样的类型，然后使用 identifier 来区分不同的 UI 元素。用户可以通过语音控制 app 的按钮点击，或是询问某个 label 的内容等等，十分方便。iOS SDK 中的控件都实现了默认的 Accessibility 支持，而我们如果使用自定义的控件的话，则需要自行使用 Accessibility 的 API 来进行添加。
     
     XCUIApplication():是一个在 UI Testing 中代表整个 app 的对象.
     1. buttons: XCUIApplication().descendantsMatchingType(.Button) 的简写形式
     2. childrenMatchingType:仅获取当前层级子元素
     3. containingType: 所有包含的元素
     以上三个的作用：获取一个对 app 的 query 对象，并返回一个XCUIElementQuery对象。我们可以通过级联和结合使用这些方法获取到我们想要的层级的元素.
     
     XCUIElementQuery：
     1. 获取：buttions获取一个对 app 的 query 对象，并返回一个XCUIElementQuery对象。
    对于 XCUIElementQuery，还有一点需要特别说明的。Query 的执行是延迟的，它和最后我们得到的 XCUIElement 并不是一一对应的。和 NSURL 与请求到的内容的关系类似，随着时间的变化，同一个 URL 有可能请求到不同的内容。我们生成 Query，然后在通过下标或者是访问方法获取的时候才真正从 app 中寻找对应的 UI 元素。这就是说，随着我们的 UI 的变化，同样的 query 也是有可能获取到不用的元素的。这在某些元素会消失或者 identifier 变化的时候是需要特别注意的。
     为了获取UI元素准确：我们可以通过在 Interface Builder 或者代码中，对这两个 textfield 的 identifier属性进行设置，这样就可以使用下标的方式进行访问了。
     

     XCUIElement: UI 元素在测试框架中的代理，代表app中具体UI元素。
     1. 获取：当得到一个可用的 XCUIElementQuery 后，我们就可以进一步地获取代表 app 中具体 UI 元素,我们不能直接通过得到的 XCUIElement 来直接访问被测 app 中的元素，而只能通过 Accessibility 中的像是 identifier 或者 frame 这样的属性来获取 UI 的信息。
     2. 使用：通过包括 typeText(text:String),tap(),doubleTap()等触发事件和属性值设置方法
     
     
     XCUIElementAttributes: UI元素中包含的各个属性，包括：identifier，frame,title,label等...
      1. 使用: 可使用这些属性来获取UI元素对象。
     */
    func testOnclickLikeView()
    {
        let username = "hsg"
        let password = "123"
        //
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = XCUIApplication()
        //获取userNameTextField
        let userNameTextField = app.textFields.elementBoundByIndex(0)
        let passWordSecureTextField = app.secureTextFields.elementBoundByIndex(0)
        userNameTextField.tap()
        userNameTextField.typeText(username)
        passWordSecureTextField.tap()
        passWordSecureTextField.typeText(password)
        
        app.buttons["Login======="].tap()
        sleep(5)
        
        let query:XCUIElementQuery = XCUIApplication().descendantsMatchingType(.Button)
        
        let navTitle = app.navigationBars[username].staticTexts[username]
        expectationForPredicate(NSPredicate(format: "exists == 1"), evaluatedWithObject: navTitle, handler: nil)
        
        let switchui = app.switches.elementBoundByIndex(0)
        switchui.tap()
        
        /*/
         在UI test测试中，无法检测控件的具体属性是否正确。
         因为：XCUIElement是特有的类，不支持类型转换
         
         let button = app.buttons.elementBoundByIndex(0)
         let predicate = NSPredicate.init { (anyobject, bindings) -> Bool in
         //
         let button = anyobject as! UIButton
         return button.backgroundImageForState(.Normal) != nil
         }
         expectationForPredicate(predicate, evaluatedWithObject: button, handler: nil)
         waitForExpectationsWithTimeout(20, handler: nil)
         */
        
        
        sleep(3)
        
//        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
}
