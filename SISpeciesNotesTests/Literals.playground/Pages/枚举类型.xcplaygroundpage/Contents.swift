//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: 枚举声明
enum CompassPoint:String{
    case East = "北方"
    case North
    case South
    case West
}
let zhixiang = CompassPoint.East

//: 枚举原始值
switch zhixiang
{
case .East:
    print("原始值：\(CompassPoint.East.rawValue)")
case .North:
    print("YES")
default:
    print("NO")
}

//: 关联值
enum Barcode
{
    case UPCA(Int,Int,Int,Int)
    case QRCode(String)
}

//: 枚举关联值的使用
let productBarcode = Barcode.UPCA(1, 2, 3, 4)
switch productBarcode
{
case .UPCA(let first, let second, let three,let four):
    print("\(first), \(second),\(three),\(four)")
case .QRCode(let qr):
    print("QRCode:\(qr)")
}

let productQRCode = Barcode.QRCode("dhikden")
switch productQRCode
{
case .QRCode(let qr):
    print("QRCode:\(qr)")
default:
    print("NO")
}

//: 递归枚举
//: 算术表达式的一个重要特性是，表达式可以嵌套使用。例如，表达式(5 + 4) * 2，乘号右边是一个数字，左边则是另一个表达式。因为数据是嵌套的，因而用来存储数据的枚举类型也需要支持这种嵌套——这意味着枚举类型需要支持递归

enum ArithmeticExpression
{
    case Number(Int)
    indirect case Addition(ArithmeticExpression,ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression,ArithmeticExpression)
}

//:上面定义的枚举类型可以存储三种算术表达式：纯数字、两个表达式相加、两个表达式相乘。枚举成员Addition和Multiplication的关联值也是算术表达式——这些关联值使得嵌套表达式成为可能

func evaluate(expression:ArithmeticExpression)->Int
{
    switch expression
    {
    case .Number(let expression):
        return expression
    case .Addition(let left, let right):
        return evaluate(left)  + evaluate(right)
    case .multiplication(let left , let right):
        return evaluate(left) * evaluate(right)
    }
}
//该函数如果遇到纯数字，就直接返回该数字的值。如果遇到的是加法或乘法运算，则分别计算左边表达式和右边表达式的值，然后相加或相乘。

//5
let five = ArithmeticExpression.Number(5)
//4
let four = ArithmeticExpression.Number(4)
//5+4
let addition = ArithmeticExpression.Addition(five, four)
//(5+4)*2
let multiplication = ArithmeticExpression.multiplication(addition, ArithmeticExpression.Number(2))

evaluate(multiplication)

































//: [Next](@next)
