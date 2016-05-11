//: [Previous](@previous)

import Foundation
import JavaScriptCore
import UIKit
import Mustache

//JSExportAs对象
//[swift版本](https://gist.github.com/zeitiger/1387f7d996f64b493608.js )
//[oc版本：宏定义](xcdoc://?url=developer.apple.com/library/etc/redirect/xcode/ios/1151/documentation/JavaScriptCore/Reference/JSExport_Ref/index.html )

public typealias myFunctionDefAlias = (@convention(block) (String, String) -> Person)

//目的：
//1. 定义一个 Person 模型符合 JSExport 子协议 PersonJSExports 的例子
//2. 然后使用 JavaScript 从 JSON 文件中创建并填充实例。
    //都有一个完整的 JVM 在那儿了，谁还需要 NSJSONSerialization？

// Custom protocol must be declared with `@objc`
@objc protocol PersonJSExports:JSExport {
    //
    var firstName:String{get set}
    var lastName:String{get set}
    var birthYear: NSNumber? { get set }
    func getFullName() -> String
    
    /// create and return a new Person instance with `firstName` and `lastName`
    static func createWithFirstName(firstName: String, lastName: String) -> Person
    
    //JSExportAs对象
    static var creatPerson:myFunctionDefAlias!{get}
}

// Custom class must inherit from `NSObject`
// Person 类实现了 PersonJSExports 协议，该协议规定哪些属性在 JavaScript 中可用
@objc(Person)
public class Person:NSObject,PersonJSExports{
    
    // properties must be declared as `dynamic`
    dynamic var firstName: String
    dynamic var lastName: String
    dynamic var birthYear: NSNumber?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    //函数变量：JSContext 访问我们的本地客户端代码的方式主要有两种：block 和 JSExport 协议
    static var creatPerson:myFunctionDefAlias! = {(foo:String, bar:String) in
        return Person(firstName: foo, lastName: bar)
    }
    
    //1. 由于JavaScriptCore 没有初始化，不能像原生的 JavaScript 类型那样简单地用 var person = new Person()，所以 create... 类方法是必要的
    //2: 由于 JavaScript 没有参数 名称，任何外部参数名称都会被转换为驼峰形式并且附加到函数名后。在这个例子中，Objective-C 的方法 createWithFirstName:lastName: 变成了在JavaScript中的 createWithFirstNameLastName()。
    //3. 在JSPatch可以调用被dynamic修饰的方法，在此处即使dynamic修饰，js中调用createWithFirstNameLastName同样失败
    dynamic class func createWithFirstName(firstName: String, lastName: String) -> Person {
        return Person(firstName: firstName, lastName: lastName)
    }

    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}
/* 继承NSObject的类，无法实现MustacheBoxble协议，否则实现协议的计算属性时，出现被overrite的特性
extension Person:MustacheBoxable{
    
        var mustacheBox: MustacheBox{
            return MustacheBox(value: self, keyedSubscript: { (key: String) in
                switch key {
                case "getFullName":
                    return Box("\(self.firstName) \(self.lastName)")
                case "birthYear":
                    return Box(self.birthYear)
                default:
                    return Box()
                }
            })
        }
}
*/

// #### JSContext 配置
let context = JSContext()
// export Person class
//===========导入Person类 到 JavaScript 环境，无效：在JS脚本中调用静态方法：class func createWithFirstName()=======
//[对象下标索引](http://nshipster.cn/object-subscripting/ )
context.setObject(Person.self, forKeyedSubscript: "Person")
//OC版本:context[@"Person"] = [Person class];
//========================

//使用block形式创建Person实例对象，然后配置到context中
//let person = Person.creatPerson("eee","ddd")
context.setObject(unsafeBitCast(Person.creatPerson, Person.self), forKeyedSubscript: "creatPerson")


// load Mustache.js
if let mustacheJSString = try? NSString(contentsOfURL:[#FileReference(fileReferenceLiteral: "Mustache.js")#], encoding:NSUTF8StringEncoding) {
    context.evaluateScript(mustacheJSString as String)
}

// get JSON string
if let peopleJSON = try? NSString(contentsOfURL:[#FileReference(fileReferenceLiteral: "Persons.json")#], encoding: NSUTF8StringEncoding) {
    print([peopleJSON])
    // get load function
    let load = context.objectForKeyedSubscript("loadPeopleFromJSON")
    // call with JSON and convert to an array of `Person`
    if let people = load.callWithArguments([peopleJSON]).toArray() as? [Person] {
        print("\(people)")
        // get rendering function and create template
        //用Mustache模板渲染。导入 Mustache JS library，应用模板到我们的 Person 对象。
//        let mustacheRender = context.objectForKeyedSubscript("Mustache").objectForKeyedSubscript("render")
        let template = "{{getFullName}}, born {{birthYear}}"
        let template2 = try! Template(string: template)
        
        
        // loop through people and render Person object as string
        for person in people {
//            print(mustacheRender.callWithArguments([template, person]))
            let rendering2 = try! template2.render(Box(person))
            print(rendering2)
        }
    }
}

// Output:
// Grace Hopper, born 1906
// Ada Lovelace, born 1815
// Margaret Hamilton, born 1936


//: [Next](@next)
