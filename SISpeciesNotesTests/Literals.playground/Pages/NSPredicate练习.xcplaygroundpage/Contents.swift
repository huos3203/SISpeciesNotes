//: [Previous](@previous)  


//:[源地址](http://nshipster.cn/nspredicate/)
//:[swift版](http://nshipster.com/nspredicate/)

import Foundation


//数据源
var firstNames = ["Alice","Bob","Charlie","Quentin"]
var lastNames = ["Smith","Jones","Smith","Alberts"]
var ages = [24,17,33,31]


//声明对象
class Person: NSObject {
    let firstName: String
    let lastName: String
    let age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    override var description: String {
        return "\(firstName) \(lastName)"
    }
}

//对象数组
var people = [Person]()

for (index,value) in firstNames.enumerate()
{
 
    let person = Person(firstName: value, lastName: lastNames[index], age: ages[index])
    
    people.append(person)
}

print(people[3].firstName)
//开始查询
//字符查询
let firstNamePredicate = NSPredicate(format: "firstName = %@","Alice")
let firstNameResult:Array = (people as NSArray).filteredArrayUsingPredicate(firstNamePredicate)
print(firstNameResult[0].firstName!)


//数字查询
let agePredicate = NSPredicate(format: "age == 24")
let ageResult = (people as NSArray).filteredArrayUsingPredicate(agePredicate)

let thirtiesPredicate = NSPredicate(format: "age >= 30")
(people as NSArray).filteredArrayUsingPredicate(thirtiesPredicate)



//输出结果





















//: [Next](@next)
