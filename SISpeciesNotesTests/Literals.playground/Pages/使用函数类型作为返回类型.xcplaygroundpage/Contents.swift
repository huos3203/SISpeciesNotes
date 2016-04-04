//: [Previous](@previous)

import Foundation

//计算平方的函数
func Square(val:Int)->Int
{
    return val * val
}
Square(4)

//计算立方的函数
func cube(val:Int)->Int
{
    return val * val * val
}

//计算一个计算阶乘的函数
func factorial(val:Int)->Int
{
    var result = 1
    for index in 2...val
    {
        result *= index
    }
    return result
}

//定义返回以上函数类型的函数
func getMathFunc(type:String)->(Int)->Int
{
    switch type {
    case "Square":
        return Square
    case "cube":
        return cube
    default:
        return factorial
    }
}

let square = getMathFunc("Square")
square(2)


let cube1 = getMathFunc("cube")
cube1(3)


//使用外部形参名重载返回以上函数的函数,用闭包形式返回嵌套函数
func getMathFunc(type type:String)->(inout Int)->Int
{
    switch type
    {
    case "Square":
        return {(inout val:Int)->Int in val = val * val; return val}
    default:
        return{(inout val:Int)->Int in return val * val * val}
    }
}

let squareblock = getMathFunc(type:"Square")
var val = 4
squareblock(&val)   //inout形参，必须为var变量
val


//: 闭包表达式
//{(形参列)->返回类型 in 可执行语句}

//定义闭包变量,通过函数类型变量：平方:(Int)->Int可以推断出闭包的形参类型和返回值类型，所以可以省去闭包表达式的形参类型和返回值类型
let 平方:(Int)->Int = {val in return val * val}
平方(4) //调用闭包

//执行闭包
let 阶乘 = {val->Int in
            var result = 1
            for index in 2...val
            {
                result *= index
    }
    return result
}(5)


//通过gg:Int推断返回值为Int类型，通过(5)推断闭包形参类型是Int
//所以可以省去闭包表达式的形参类型和返回值类型
let gg:Int = {val in return val * val}(5)


//: [Next](@next)
