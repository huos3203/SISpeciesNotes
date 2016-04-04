//: [Previous](@previous)

import Foundation

//函数是执行特定任务的一段代码，程序通过这段代码来定义函数，并为该函数指定一个函数名，这样既可在需要的时候多次调用这段代码，因此函数代码复用的重要手段，是面向过程的。


func sayHello()
{
    let name = "张三"
    let sex = "女"
    print("My name is \(name),sex :\(sex)")
}

//睡眠好坏，有早晚有关
func sleepUp(time:NSDate)
{
//    如果晚于12点不好，早于十二点睡眠良好
//    声明闭包
    let zero:(String)->NSDate = {
        
        
        
        var dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print($0)
        let zeroDate = dateformatter.dateFromString("2016-04-03 00:00:00")!
        
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // String 转 Date
        let now = dateFormatter2.dateFromString("2016-04-05 06:00:00")!
        
        return zeroDate
    }
    
//    zero("24:00")调用闭包
    let laterdate = time.laterDate(zero("2016-04-04 24:00"))
//    可选绑定
    if laterdate.isEqualToDate(time)
    {
        print("没休息好")
    }else
    {
        print("睡眠良好")
    }
}

sleepUp(NSDate())



//使用尾随闭包
//第一步定义一个最后一个形参为闭包的函数
func sleepUp(time:NSDate,比较:(NSDate)->Bool)
{

    if 比较(time)
    {
        print("睡眠不错")
    }
    else
    {
        print("失眠啦")
    }
}

sleepUp(NSDate()) {
    
//    比较时间差 00：00
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone.localTimeZone()
    dateFormatter.dateFormat = "HH:mm:ss"
// 将00:00转为时间类型
    let zero:NSDate! = dateFormatter.dateFromString("15:00:00")
    let latertime = zero.laterDate($0)
    if latertime.isEqualToDate(zero)
    {
        return true
    }
    else
    {
        return false
    }
}









//: [Next](@next)
