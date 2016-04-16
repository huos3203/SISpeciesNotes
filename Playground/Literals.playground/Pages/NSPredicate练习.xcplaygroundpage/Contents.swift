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

//数组对象
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


//: 替换 %K:替换key path的值  %@:替换字符串    $字段名:
let lastNamePredicate = NSPredicate(format: "%K = %@", "lastName","Alberts")
(people as NSArray).filteredArrayUsingPredicate(lastNamePredicate)


// 检索firstname以"A"开头，lastName以"A"开始的用户
let namePredicate = NSPredicate(format:"(firstName beginswith[cd] $letter) or (lastName beginswith[cd] $letter)")
let name = namePredicate.predicateWithSubstitutionVariables(["letter":"A"])
(people as NSArray).filteredArrayUsingPredicate(name)



//: 字符串比较
//匹配lastname是Alberts的用户
let albertsPredicate = NSPredicate(format: "lastName contains[cd] %@", "Alberts")
(people as NSArray).filteredArrayUsingPredicate(albertsPredicate)

//like ?,*通配符
let tpPredicate = NSPredicate(format: "lastName like '*erts'")



//NSCompoundPredicate


//输出结果


let predicatea = NSPredicate(format:"SELF IN %@", ["Stig", "Shaffiq", "Chris"])
let result = predicatea.evaluateWithObject("Shaffiq")
result


let attributeValue = "joys"
let attributeValue1 = "Toms"
//如果使用%@，会出现：The predicate format string in this case evaluates to "firstName" like "Adam".
let predicate = NSPredicate(format: "%K like %@", attributeValue1,attributeValue)


//: MATCHES正则使用
let matchesPredicate = NSPredicate(format: "self.firstname matches %@", "*.mith")
let matchesResult = (people as NSArray).filteredArrayUsingPredicate(matchesPredicate)

















//: [Next](@next)
