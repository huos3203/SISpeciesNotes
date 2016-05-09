//: [Previous](@previous)

import Foundation
//: [JavaScriptCore框架在iOS7中的对象交互和管理](http://blog.iderzheng.com/ios7-objects-management-in-javascriptcore-framework/)
//: [原文](http://nshipster.cn/javascriptcore/)
//OS X Mavericks 和 iOS 7 引入了 JavaScriptCore 库，它把 WebKit 的 JavaScript 引擎用 Objective-C 封装，提供了简单，快速以及安全的方式接入世界上最流行的语言。
import JavaScriptCore

//JSContext 是运行 JavaScript 代码的环境。一个 JSContext 是一个全局环境的实例，如果你写过一个在浏览器内运行的 JavaScript，JSContext 类似于 window
let context = JSContext()
context.evaluateScript("var num = 5 + 5")
context.evaluateScript("var names = ['Grace', 'Ada', 'Margaret']")
context.evaluateScript("var triple = function(value) { return value * 3 }")
let tripleNum: JSValue = context.evaluateScript("triple(num)")

//JSValue 包括一系列方法用于访问其可能的值以保证有正确的 Foundation 类型:例如toInt32()
print("Tripled: \(tripleNum.toInt32())")
// Tripled: 30

//下标值

//对 JSContext 和 JSValue 实例使用下标的方式我们可以很容易地访问我们之前创建的 context 的任何值。
//JSContext 需要一个字符串下标，而 JSValue 允许使用字符串或整数标来->得到里面的对象和数组：
//Swift 目前只公开原始方法来让下标成为可能：objectAtKeyedSubscript() 和 objectAtIndexedSubscript()。
let names = context.objectForKeyedSubscript("names")
let initialName = names.objectAtIndexedSubscript(0)
print("The first name: \(initialName.toString())")
// The first name: Grace

//Objective-C 代码可以利用下标表示法
//JSValue *names = context[@"names"];
//JSValue *initialName = names[0];
//NSLog(@"The first name: %@", [initialName toString]);
// The first name: Grace

//调用方法

//JSValue 包装了一个 JavaScript 函数，我们可以从 Objective-C / Swift 代码中使用 Foundation 类型作为参数来直接调用该函数。再次，JavaScriptCore 很轻松的处理了这个桥接：
let tripleFunction = context.objectForKeyedSubscript("triple")
let result = tripleFunction.callWithArguments([5])
print("Five tripled: \(result.toInt32())")

//错误处理

//JSContext 还有另外一个有用的招数：通过设置上下文的 exceptionHandler 属性，你可以观察和记录语法，类型以及运行时错误。 exceptionHandler 是一个接收一个 JSContext 引用和异常本身的回调处理：
context.exceptionHandler = { context, exception in
    print("JS Error: \(exception)")
}

context.evaluateScript("function multiply(value1, value2) { return value1 * value2 ")
// JS Error: SyntaxError: Unexpected end of script

//从 JavaScript 访问我们在 Objective-C 或 Swift 定义的对象和方法
//让 JSContext 访问我们的本地客户端代码的方式主要有两种：block 和 JSExport 协议。

//Blocks

//当一个 Objective-C block 被赋给 JSContext 里的一个标识符，JavaScriptCore 会自动的把 block 封装在 JavaScript 函数里。这使得在 JavaScript 中可以简单的使用 Foundation 和 Cocoa 类，所有的桥接都为你做好了。见证了 CFStringTransform 的强大威力，现在让我们来看看 JavaScript：
let simplifyString: @convention(block) String -> String = { input in
    var mutableString = NSMutableString(string: input) as CFMutableStringRef
    CFStringTransform(mutableString, nil, kCFStringTransformToLatin, Bool(0))
    CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, Bool(0))
    return mutableString as String
}
context.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "simplifyString")

//JSContext 访问我们的本地客户端代码
print(context.evaluateScript("simplifyString('안녕하새요!')"))
// annyeonghasaeyo!

//Swfit 还有一个坑，请注意，这仅适用于 Objective-C 的 block，而不是 Swift 的闭包。要在 JSContext 中使用 Swift 闭包，它需要（a）与 @ objc_block 属性一起声明，以及（b）使用 Swift 那个令人恐惧的 unsafeBitCast() 函数转换为 AnyObject 。

//内存管理

//由于 block 可以保有变量引用，而且 JSContext 也强引用它所有的变量，为了避免强引用循环需要特别小心。避免保有你的 JSContext 或一个 block 里的任何 JSValue。相反，使用 [JSContext currentContext] 得到当前上下文，并把你需要的任何值用参数传递。



//任何出自 JSContext 的值都被包裹在一个 JSValue 对象中。
//像 JavaScript 这样的动态语言需要一个动态类型，所以 JSValue 包装了每一个可能的 JavaScript 值：字符串和数字；数组、对象和方法；甚至错误和特殊的 JavaScript 值诸如 null 和 undefined。




//: [Next](@next)
