//: [Previous](@previous)

import Foundation

let js = JSCore.newContext()
js.requireRequestModule()



func testFuntions() {
    let sumResult = js.run("sum(1, 2)") as! Int
}

func testGet() {
    let responseHTML = js.run("new Request('http://www.baidu.com/').get().match(/baidu\\.com/ig)[0]") as! String
//    XCTAssert(responseHTML == "baidu.com", "There must be a link of Baidu.")
}

func testPostFormWithNoParam() {
    let responseString = js.run("new Request('http://api.t.sina.com.cn/statuses/update.json').post(['status=test']).match(/403/g)[0]") as! NSString
    print(responseString)
//    XCTAssert(responseString == "403", "Result of postForm must not be nil.")
}

func testPostFormWithParams() {
    let responseString = js.run("new Request('http://www.hashemian.com/tools/form-post-tester.php').post([\"q=lexrus\"]).match(/lexrus/ig)[0]") as! NSString
//    XCTAssert(responseString == "lexrus", "Result of postForm must not be nil.")
}




//: [Next](@next)
