//: [Previous](@previous)


//: 重点  
// swift定义存储属性还可以指定一个可选的初始值
//: 1. swift要求类中定义的存储属性必须指定初始值，要么在定义时指定初始值，要么在构造器中指定初始值。然而结构体并没有这个要求。

//: let声明的实例存储属性和普通常量的区别：
// 普通常量必须在定义时指定初始值，而let声明的实例存储属性可以在定义时指定，或者在构造器中指定初始值。

//: 构造器（）swift语言通过类名后添加圆括号来表示调用构造器，从而返回类的实例。
//  定义构造器的语法格式：
//  [修饰符]init(形参列表){....}
//    修饰符：public/internal/private其中之一
//    swift的构造器名总是init,且构造器不嫩声明返回值类型。是隐式的返回self作为返回值。
//: 1. 如果程序中没有为一个类提供构造器，系统会为该类提供一个默认的、无参数的构造器。一旦为该类提供了构造器，系统将不再为该类提供默认的构造器。
//: 2. 类和结构体的区别
//  结构体不支持继承，不能使用final修饰[修饰符]struct 结构名称{}
//  如果程序中没有为一个该结构体提供构造器，系统会提供两个默认的构造器：一个无参数的构造器，一个是初始化所有存储属性的构造器。

// 类使用 class，Strut和枚举使用static来修饰存储属性，方法，来转成类型相关的成员，不再是实例成员。

//值类型和引用类型
//引用类型的变量中存放的仅仅是一个引用，它指向实际的实例，虽然很像OC中的指针类型，但不是指针，是引用变量
//结构体变量保存的就是结构体实例，在参数传递或赋值，值类型的实例都需要被复制副本，因此swift必须将枚举，结构体设计成轻量级的面向对象类型，所以枚举，结构体都不支持继承。

//引用类型的比较（===  ，!==）
//数据类型的比较( == ，!= )
//可选类型(比如：Int?,Double?)和nil(不是指针，是一个确定的值)
//例如：Int?类型的变量或常量既能接受Int类型的值，也可以接受nil值。
//强制解析(!)：必须可选类型的变量和常量确实有值是才能解析成功，否则就出错。
//if语句的解决办法：if str != nil{var s:String = str!},判断可选变量不是nil后，还需要强制解析。
//可选绑定：用于判断可选类型的变量和或常量是否有值，如果可选类型的变量或常量有值就赋值给另一个临时的变量或常量。
//可选绑定可用在if分支或while循环中，
//var str:String?="name" if var tmp = str!{ }
//使用if判断可选变量str是否为nil,如果str不是nil,程序就会对str执行强制解析，并将解析得到的值赋值给tmp变量，因此tmp变量的类型是String，而不是String!，因此程序可以直接将tmp变量作为String使用，无需使用感叹号(!)对tmp执行解析。

//隐式可选类型(比如：Int!,Double!)和nil
//例如：Int!类型的变量或常量既能接受Int类型的值，也可以接受nil值。
//Int?和Int!区别：就是在程序需要获取Int!类型的变量或常量的值时，无需再变量后添加(!)后缀执行强制解析，swift会自动执行隐式解析。

//: 存储属性：指的是存储在类，结构体里的变量和常量。
//枚举不能定义实例存储属性，可以定义类型存储属性。
//swift要求：所有的存储属性必须显式指定初始值，要么在定义时指定初始值，要么在构造器中指定初始值（只有实例存储属性才能在构造器中指定初始值）。
//由于结构体中默认提供所有实例存储属性的构造器：
//    1. 如果所有实例存储属性都指定了初始值，且没有自定义构造器，那么系统会提供一个无参的构造器，和一个初始化所有实例存储属性的构造器。
//  2. 如果只给部分实例存储属性指定了初始值，且没有提供自定义构造器，那么系统会提供一个初始化所有实例存储属性的构造器，不会在提供无参构造器。
//  3. 如果为结构体自定义了构造器，那么该构造器必须为所有的实例存储属性指定初始值，要么在定义时指定，要么在构造器中指定初始值。



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

//var dizhi = Address(fulladdress: "锦秋国际大厦", city: "海淀区")
//var wo = Person(name: "霍曙光", address: dizhi)
//var ni = Person(name: "小米", address: dizhi)
//print(wo.address.fulladdress)
//
////类是引用类型
//ni.address.fulladdress = "二拨子"
//print(ni.address.fulladdress)
//print(wo.address.fulladdress)



//延迟存储属性：lazy
class Dept
{
    var id = 0
    var info = ""
    init(id:Int)
    {
        self.id = id
        NSThread.sleepForTimeInterval(10)
        print("Dept成功创建")
    }
}

//用户

class User
{
//    存储属性
    let name:String
    lazy var dept = Dept(id:20)
//    构造器
    init()
    {
        name = "self.user"
    }
    func userDo()
    {
        print("name = 7777")
    }
    
}

//let user = User()
//user.dept


//计算属性
//需求：姓，名，和全称之间的转换
class UserName
{
    var firstName = ""
    var lastName = ""
    
    init(first:String,last:String)
    {
        self.firstName = first
        self.lastName = last
    }
    
    var fullName:String{
        get{
            return firstName + "-" + lastName
        }
        
        set(newValue)
        {
            var names = newValue.componentsSeparatedByString("-")
            self.firstName = names[0]
            self.lastName = names[1]
        }
    }
}

let username = UserName(first: "张",last: "三")
username.fullName
username.fullName = "李-四"
username.firstName
username.lastName

enum Season {
    case Spring,Summer,Fall,Winter
    var info:String{
        get{
            switch (self) {
            case .Spring:
                return "炎热夏季"
            default:
                return "春季将至"
            }
        }
        
        set(sinfo)
        {
            print("季节美好：\(sinfo)")
        }
    }
}

var se = Season.Spring
se.info

//se.info = "烈日炎炎"













//: [Next](@next)
