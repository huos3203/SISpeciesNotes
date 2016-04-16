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

//:“函数首先计算出有多少字符需要被添加到string的左边，从而将其在整个字符串中右对齐。这个值存储在一个称为amountToPad的本地常量。如果不需要填充（也就是说，如果amountToPad小于1），该函数简单地返回没有任何填充的输入值string。”
func addLeft(var sourceStr:String, maxLen:Int)
{
    //缺少的字符数
    var number = maxLen - sourceStr.characters.count
    
    if number > 0
    {
            //添加占位符
        for _ in 1...number
        {
            sourceStr = "-" + sourceStr
        }
        
    }
    print(sourceStr)
}


addLeft("rrr", maxLen: 10)


//:switch 

let somechar = "e"
switch somechar
{
    case "A","w","e":
    print("the char "+somechar)
    
    case "r","y","m":
    print("the char is r")
default:
    print("exit char "+somechar)
}

//:switch区间值比较

let 时间 = 6
switch 时间
{
case 1...5:
    print("1到5区间")
case 3..<6:
    print("大于3小于6")
case 4...6:
    print("大于等于4且小于等于6")
default:
    print("没有匹配的区间")
}

//:switch元组比较

let somePoint = (1,6)

switch somePoint
{
case (1,8):
    print("x=1,y=8")
case (1,6):
    print("x=1,y=6")
case (_,1):
    print("x任意,y=1")
case (1,_):
    print("x=1,y任意")
case(0...4,3...7):
    print("0<=x<=4,3<=y<=7")
    
default:
    print("无匹配元组")
}

//:where使用
switch somePoint
{
case(let x,let y) where x == y:
    print("x任意，y任意")
case (let x, let y) where x < y:
    print("x=\(x),y=\(y)")
default:
    print("无匹配元组")
}

//:continue
let 姓名 = "RenCaiLiangKong"
var 名字 = ""
for 字母 in 姓名.characters
{
    switch 字母
    {
    case "r","C","L","K":
        continue
    default:
        名字.append(字母)
    }
    print(名字)
}










