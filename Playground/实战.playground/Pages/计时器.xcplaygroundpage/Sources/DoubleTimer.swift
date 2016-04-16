import Foundation

extension Double
{
    //秒
    public var second:Double{ return self}
    //分
    public var minute:NSTimeInterval{return self * 60}
    //小时
    public var hour:NSTimeInterval{return self * 60 * 60}
    //天
    public var day:NSTimeInterval{return self * 60 * 60 * 24}
}
