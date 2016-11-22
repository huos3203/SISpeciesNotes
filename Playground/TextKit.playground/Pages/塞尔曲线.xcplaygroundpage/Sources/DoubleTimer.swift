import UIKit

extension Double{
    //秒
    public var second:Double{ return self}
    //分
    public var minute:TimeInterval{return self * 60}
    //小时
    public var hour:TimeInterval{return self * 60 * 60}
    //天
    public var day:TimeInterval{return self * 60 * 60 * 24}
    
    //M_PI 定义在Math.h内，其值为3.14159265358979323846264338327950288
    //角度转弧度:45
    public var degreesToRadians:CGFloat{
        return (CGFloat(M_PI) * CGFloat(self))/180
    }
    
    //弧度转角度:0.785398
    public var radiansToDegrees:CGFloat{
        
        return CGFloat(self * (180.0 / M_PI))
    }
}
