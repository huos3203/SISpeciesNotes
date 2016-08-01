//: [Previous](@previous)   [原地址](http://swifter.tips/playground-delay/)

//: #### 问题：
//: 异步代码在执行完 NSTimer 语句之后，整个 Playground 将停止掉，Hi 永远不会被打印出来。放心，这种异步的操作没有生效并不是因为你写错了什么，而是 Playground 在执行完了所有语句，然后正常退出了而已
//: #### 解决：
//: 引入 Playground 的 “扩展包” XCPlayground 框架,其中就包括使 Playground 能延时执行的黑魔法，XCPSetExecutionShouldContinueIndefinitely使 Playground 具有延时运行的本领.

//: [Next](@next)

import Foundation
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely(true)

//: 关于 selector 的使用 和 @objc 标记可以分别参见 Selector 以及 @objc 和 dynamic。
class MyClass {
    @objc func callMe() {
        print("Hi")
    }
}

let object = MyClass()

NSTimer.scheduledTimerWithTimeInterval(1, target: object,
    selector: "callMe", userInfo: nil, repeats: true)



//: 在实际使用和开发中，我们最经常面临的异步需求可能就是网络请求了，如果我们想要在 Playground 里验证某个 API 是否正确工作的话，使用 XCPlayground 的这个方法开启延时执行也是必要的：
let url = NSURL(string: "http://httpbin.org/get")!

let getTask = NSURLSession.sharedSession().dataTaskWithURL(url) {
    (data, response, error) -> Void in
    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
    
    print(dictionary)
}

//getTask.resume()

//: 延时运行也是有限度的。如果你足够有耐心，会发现在第一个例子中的 NSTimer 每秒打印一次的 Hi 的计数最终会停留在 30 次。这是因为即使在开启了持续执行的情况下，Playground 也不会永远运行下去，默认情况下它会在顶层代码最后一句运行后 30 秒的时候停止执行。这个时间长度对于绝大多数的需求场景来说都是足够的了，但是如果你想改变这个时间的话，可以通过 Alt + Cmd + 回车 来打开辅助编辑器。在这里你会看到控制台输出和时间轴，将右下角的 30 改成你想要的数字，就可以对延时运行的最长时间进行设定了。





