//: [Previous](@previous)

import Foundation
import UIKit

//: [Next](@next)

//: #### 取余运算符,与 'C' 不同：Swift中的运算符可以对浮点数取余
var 余数 = 8%2.5
print(余数)
//let imageUrl = "http://img1.tuicool.com/Q7bEZz2.jpg!web"
//let imageData:NSData! = NSData(contentsOfURL: NSURL(string: imageUrl)!)
//let imageView = UIImageView.init(image: UIImage(data: imageData!))


//: #### 溢出运算符  &+ ，&-，&*...
var minValue = UInt8.min //UInt8类型最小值
var maxValue = UInt8.max //UInt8类型最大值

//let a1 = maxValue + 1  //程序运行到该行时崩溃
let a2 = maxValue &+ 1
print(a2)

let a3 = minValue &- 1
print(a3)

/*: 
#### 闭区间运算符：a...b；开区间运算符：a..<b
Swift中的 闭区间运算符(a...b) 相当于 a <= x <= b，开区间运算符(a..<b) 相当于 a <= x < b
*/
var num : Int
for i in 0...6 {
    num = i   // 该语句执行7次
}
for i in 0..<6 {
    num = i   // 该语句执行6次
}

/*:
#### a ?? b
Swift中的 空合并运算符 表示对 a 进行空判断，如果 a包含一个值 就对 a 进行解析，否则将 b 转化为 Optional类型 并返回
*/
var aStr:String? = "aaa"
let bStr = "bbb"
var result = aStr ?? bStr
print(result)

var a:Int?   //a = nil
let b = 4
print(b)
a = a ?? b
print(a)


