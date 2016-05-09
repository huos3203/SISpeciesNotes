//: [Previous](@previous)

import Foundation
import JavaScriptCore
import UIKit

let context = JSContext()
//目的：定义一个 Person 模型符合 JSExport 子协议 PersonJSExports 的例子，然后使用 JavaScript 从 JSON 文件中创建并填充实例。都有一个完整的 JVM 在那儿了，谁还需要 NSJSONSerialization？

// Custom protocol must be declared with `@objc`
@objc protocol PersonJSExports:JSExport {
    //
    var firstName:String{get set}
    var lastName:String{get set}
    var birthYear: NSNumber? { get set }
    
    func getFullName() -> String
    
    /// create and return a new Person instance with `firstName` and `lastName`
    static func createWithFirstName(firstName: String, lastName: String) -> Person
}

// Custom class must inherit from `NSObject`
// Person 类实现了 PersonJSExports 协议，该协议规定哪些属性在 JavaScript 中可用
@objc class Person:NSObject,PersonJSExports{
    
    // properties must be declared as `dynamic`
    dynamic var firstName: String
    dynamic var lastName: String
    dynamic var birthYear: NSNumber?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    //由于 JavaScriptCore 没有初始化，所以 create... 类方法是必要的，我们不能像原生的 JavaScript 类型那样简单地用 var person = new Person()。
    //这段代码将创建新的 Person 实例。
    //javaScriptCore 转换的 Objective-C / Swift 方法名是 JavaScript 兼容的。由于 JavaScript 没有参数 名称，任何外部参数名称都会被转换为驼峰形式并且附加到函数名后。在这个例子中，Objective-C 的方法 createWithFirstName:lastName: 变成了在JavaScript中的 createWithFirstNameLastName()
    class func createWithFirstName(firstName: String, lastName: String) -> Person {
        return Person(firstName: firstName, lastName: lastName)
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}



//之前，我们可以用我们已经创建的 Person 类，我们需要将其导出到 JavaScript 环境。我们也将借此导入 Mustache JS library，我们将应用模板到我们的 Person 对象。

// #### JSContext 配置
// export Person class   //context[@"Person"] = [Person class];
//[对象下标索引](http://nshipster.cn/object-subscripting/ )
context.setObject(Person.self, forKeyedSubscript: "Person")


// load Mustache.js
if let mustacheJSString = try? NSString(contentsOfURL:[#FileReference(fileReferenceLiteral: "Mustache.js")#], encoding:NSUTF8StringEncoding) {
    context.evaluateScript(mustacheJSString as String)
}

// get JSON string
if let peopleJSON = try? NSString(contentsOfURL:[#FileReference(fileReferenceLiteral: "Persons.json")#], encoding: NSUTF8StringEncoding) {
    print([peopleJSON])
    // get load function
    let load = context.objectForKeyedSubscript("loadPeopleFromJSON")
    
    let peoples = context.objectForKeyedSubscript("loadPeople")
    let ddd = load.callWithArguments([peopleJSON])
    let result = peoples.callWithArguments(["dddd"])
    print("\(result.toArray)")
    // call with JSON and convert to an array of `Person`
    if let people = load.callWithArguments([peopleJSON]).toArray() as? [Person] {
        
        // get rendering function and create template
        //用Mustache模板渲染
        let mustacheRender = context.objectForKeyedSubscript("Mustache").objectForKeyedSubscript("render")
        let template = "{{getFullName}}, born {{birthYear}}"
        
        // loop through people and render Person object as string
        for person in people {
            print(mustacheRender.callWithArguments([template, person]))
        }
    }
}

// Output:
// Grace Hopper, born 1906
// Ada Lovelace, born 1815
// Margaret Hamilton, born 1936


//: [Next](@next)
