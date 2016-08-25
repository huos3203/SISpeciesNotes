//: [Previous](@previous)

import Foundation


//通过尾随函数中的算法，来筛选对应的元素
var str = [1, 2, 3, 4, 5, 6]
print(str)
var str1 = str.filter{ $0 % 2 == 0 }  //筛选
print(str1)
var str2 = str.map{$0 * 5}            //乘法
print(str2)
var str3 = str.reduce(0, combine: +)  //加法
print(str3)




//: [Next](@next)


