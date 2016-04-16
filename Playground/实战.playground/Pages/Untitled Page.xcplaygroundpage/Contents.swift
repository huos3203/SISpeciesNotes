//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var arr = ["QQ:","手机:","\n","邮箱:"]
extension String
{
    mutating func replaceString(Arr:Array<String>) -> String {
        let str:String!
        for item in Arr {
            print(item)
            self = self.stringByReplacingOccurrencesOfString(item, withString: " ")
            print(self)
        }
        return self
    }
}

var waterMark = "QQ:12343\n 邮箱:email \n手机:123343"
waterMark = waterMark.replaceString(arr)
print(waterMark)

