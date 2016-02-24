//: [Previous](@previous)

import Foundation

class Address
{
    //城市  //街名
    var city = ""
    var fulladdress = ""
    init(fulladdress:String,city:String)
    {
        self.city = city
        self.fulladdress = fulladdress
    }
}

class Person
{
    //名字   //住址
    var name = ""
    var address:Address
    init(name:String ,address:Address)
    {
        self.name = name
        self.address = address
    }
}

var dizhi = Address(fulladdress: "锦秋国际大厦", city: "海淀区")
var wo = Person(name: "霍曙光", address: dizhi)
var ni = Person(name: "小米", address: dizhi)
print(wo.address.fulladdress)

ni.address.fulladdress = "二拨子"
print(ni.address.fulladdress)
print(wo.address.fulladdress)












//: [Next](@next)
