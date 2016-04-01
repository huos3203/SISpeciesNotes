//: [Previous](@previous)

import Foundation

var str = "Hello, playground"


//数据源
var firstNames = ["Alice","Bob","Charlie","Quentin"]
var lastNames = ["Smith","Jones","Smith","Alberts"]
var ages = [24,17,33,31]


//声明对象
class Person: NSObject {
    let name: String
    let lastName: String
    let age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.name = firstName
        self.lastName = lastName
        self.age = age
    }
    
    override var description: String {
        return "\(name) \(lastName)"
    }
}

//数组对象
var people = [Person]()

for (index,value) in firstNames.enumerate()
{
    
    let person = Person(firstName: value, lastName: lastNames[index], age: ages[index])
    
    people.append(person)
}




let isbnTestArray = ["123456789X", "987654321x", "1234567890", "12345X", "1234567890X"]
let isbnPredicate =
NSPredicate(format: "SELF MATCHES '\\\\d{10}|\\\\d{9}[Xx]'")

let isbnArray = (isbnTestArray as NSArray).filteredArrayUsingPredicate(isbnPredicate)





//: MATCHES正则使用
let matchesPredicate = NSPredicate(format: "SELF.name MATCHES %@","Alice")
let matchesResult = (people as NSArray).filteredArrayUsingPredicate(matchesPredicate)






















//: [Next](@next)
