//: [Previous](@previous)

import Foundation

//: 1. 如果第一个字符串（s1）大于第二个字符串（s2），backwards(_:_:)函数返回true，表示在新的数组中s1应该出现在s2前。
//: 2. 对于字符串中的字符来说，“大于”表示“按照字母顺序较晚出现”。这意味着字母"B"大于字母"A"，字符串"Tom"大于字符串"Tim"。该闭包将进行字母逆序排序，"Barry"将会排在"Alex"之前。

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func sortname(first:String,second:String)->Bool
{
    return first > second
}

var sortnames = names.sort(sortname)
print(sortnames)


/*: 
闭包表达式语法有如下一般形式：

    { (parameters) -> returnType in
        statements
    }
1. 闭包表达式语法可以使用常量、变量和inout类型作为参数，不能提供默认值。也可以在参数列表的最后使用可变参数。元组也可以作为参数和返回值。
2. in : 闭包的函数体部分由关键字in引入。该关键字表示闭包的参数和返回值类型定义已经完成，闭包函数体即将开始.
*/
var sortnamess = names.sort(
    {(s1:String,s2:String)->Bool in
        return s1 > s2
    }
)
print(sortnamess)


/*:
#### 根据上下文推断类型
实际上任何情况下，通过内联闭包表达式构造的闭包作为参数传递给函数或方法时，都可以推断出闭包的参数和返回值类型。 这意味着闭包作为函数或者方法的参数时，您几乎不需要利用完整格式构造内联闭包。

1. 因为排序闭包函数是作为sort(_:)方法的参数传入的，Swift 可以推断其参数和返回值的类型。
2. sort(_:)方法被一个字符串数组调用，因此其参数必须是(String, String) -> Bool类型的函数。这意味着(String, String)和Bool类型并不需要作为闭包表达式定义的一部分。
3. 因为所有的类型都可以被正确推断，返回箭头（->）和围绕在参数周围的括号也可以被省略：
*/
var sortnamesss = names.sort({s1, s2 in return s1 > s2})
print(sortnamesss)


/*:
#### 单表达式闭包隐式返回
sort(_:)方法的第二个参数函数类型明确了闭包必须返回一个Bool类型值。因为闭包函数体只包含了一个单一表达式（s1 > s2），该表达式返回Bool类型值，因此这里没有歧义，return关键字可以省略。
*/

var sortWithoutReturn = names.sort({s1,s2 in s1 > s2})
print(sortWithoutReturn)

//: #### 参数名称缩写
//: Swift 自动为内联闭包提供了参数名称缩写功能，您可以直接通过$0，$1，$2来顺序调用闭包的参数，以此类推。
//: 1. 如果您在闭包表达式中使用参数名称缩写，您可以在闭包参数列表中省略对其的定义，并且对应参数名称缩写的类型会通过函数类型进行推断。
//: 2. in关键字也同样可以被省略，因为此时闭包表达式完全由闭包函数体构成:
var sortOutName = names.sort({$0 > $1})
print(sortOutName)



//: #### 运算符函数
//: Swift 的String类型定义了关于大于号（>）的字符串实现，其作为一个函数接受两个String类型的参数并返回Bool类型的值。而这正好与sort(_:)方法的第二个参数需要的函数类型相符合。因此，您可以简单地传递一个大于号，Swift 可以自动推断出您想使用大于号的字符串函数实现:
var sortOutAny = names.sort(>)
print(sortOutAny)

/*: 
#### 尾随闭包
 尾随闭包： 是书写在函数括号之后的闭包表达式。

 在swift中如果要将`很长的闭包表达式`作为最后一个参数传给函数时，可以使用尾随闭包来提高代码的可读性。

 函数支持将闭包表达式作为最后一个参数调用

 如果函数只需要闭包表达式一个参数，当您使用尾随闭包时，您甚至可以把()省略掉
*/
// 标准尾随闭包表达式
var sort = names.sort(){(s1:String,s2:String) -> Bool in return s1 > s2}
// 推断类型
var sorttype = names.sort(){s1,s2 in return s1 > s2}
var sorttype2 = names.sort{s1,s2 in return s1 > s2}
// 隐藏返回
var sortname = names.sort(){s1,s2 in s1 > s2}
var sortname2 = names.sort{s1,s2 in s1 > s2}
// 参数名称缩写
var sortyasuo = names.sort(){$0 > $1}
var sortyasuo2 = names.sort{$0 > $1}
// 运算符函数
//var sortfunc = names.sort()>


/*:
 #### map(_)方法
该方法获取一个闭包表达式作为其唯一参数。该闭包函数会为数组中的每一个元素调用一次，并返回该元素所映射的值。具体的映射方式和返回值类型由闭包来决定。

*/

let digitNames = [0:"Zero",1:"One",2:"Two",3:"Three",4:"Four",5:"Five",6:"Six",7:"Seven",8:"Eight",9:"Nine"]
let numbers = [16,234,56]
var digitNum = numbers.map{
    (var number) ->String in
    var output = ""
    while number > 0{
        output = digitNames[number % 10]! + output
        number/=10
    }
    return output
}
print(digitNum)


//: 内嵌函数实现闭包捕获值的实现

func makeIncementor(forIncrement count:Int) -> () ->Int{

    //变量
    var runingCount = 0
    func Incementor() ->Int
    {
        runingCount += count
        return runingCount
    }
    
    return Incementor
}

let incementByTen = makeIncementor(forIncrement: 10)
incementByTen()
incementByTen()
incementByTen()



//: 自动闭包，先在有利的上下文下声明，捕获值，再在需要的时候执行







//: [Next](@next)
