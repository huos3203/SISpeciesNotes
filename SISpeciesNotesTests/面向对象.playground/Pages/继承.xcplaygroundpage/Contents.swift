//: [Previous](@previous)

import Foundation
//面向对象三大特性：封装，继承，多态：swift类型（类，枚举，结构体）
//继承（override）:仅有类才能有的特性，是区别于其他类型的基本特征。
//具有单继承的特点。
//不用于OC的是，swift的类并不是从一个通用的积累继承而来，如果不显示的为一个类指定父类，那么该类将没有没有父类，它不会继承NSObject或Object之类。

//super:在重写的父类方法中使用super,用于限定调用它从父类继承的属性和方法。如果在构造器中使用super,用户限定该构造器初始化的从父类继承得到的属性，而不是该类自己定义的属性。

//重写父类的属性（存储属性、计算属性），一定要使用override修饰符。
//1. 可以通过定制getter或setter或添加属性观察者的方式来重写属性，不能只是简单的定义一个与父类中同名的存储属性去重写父类的属性，因为swift不允许在子类中定义与父类同名的存储属性。
//2. 重写父类的属性时，一定要将属性的名字和类型都写出来。
//3. 可以将父类的只读属性改写为读写属性，但不能将父类中的读写属性重写成只读属性。
//   只要为计算属性提供了setter方法，就必须提供对应的getter方法，在重写属性时也不例外，此时在该getter方法中写上 return super.属性名, 就可以了。
//水果类
class Fruit
{
//    属性
    var weight = 0
    
//    方法
    func info()
    {
        print("水果类")
    }
}
let fruit = Fruit()
fruit.info()

//苹果类
class Apple:Fruit
{
//    属性
    var name:String?
    
//    构造器
    override init() {
        super.init()
        name = "苹果"
    }
    
    //方法
    override func info() {
        print("我是苹果")
    }

}








//: [Next](@next)
