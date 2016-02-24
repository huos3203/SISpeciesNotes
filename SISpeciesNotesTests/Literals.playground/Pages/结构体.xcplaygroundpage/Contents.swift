//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//类声明
class VideoModel
{
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name:String?
}


//结构体声明
struct Resolution
{
    var with = 0
    var height = 0
}

//类和结构体实例
let someVideo = VideoModel()
let someResolution = Resolution()

//属性访问
print("电视大小：\(someVideo.frameRate)")

//结构体类型的成员逐一构造器
var vag = Resolution(with: 100, height: 300)

//: 结构体和枚举是值类型
let vag2 = vag
print(vag.height)
print("vag2.height = \(vag2.height)")

//修改结构体的属性height
vag.height = 400
print(vag.height)
//vag2的高度不受影响，因为是值类型，结构体实例被复制
print("vag2.height = \(vag2.height)")

//枚举类型是值类型
enum CompassPoint
{
    case East,North,South,West
}

var currentDirection = CompassPoint.East
let rememberDirection = currentDirection
currentDirection = .North
if(rememberDirection == .East){
    print("值没有被改变")
}
//上例中rememberedDirection被赋予了currentDirection的值，实际上它被赋予的是值的一个拷贝。赋值过程结束后再修改currentDirection的值并不影响rememberedDirection所储存的原始值的拷贝。




//: 类是引用类型
let tenEight = VideoModel()
let hd = Resolution(with: 800, height: 1800)
tenEight.interlaced = true
tenEight.frameRate = 25.0
tenEight.resolution = hd
tenEight.name = "1800i"







//: [Next](@next)
