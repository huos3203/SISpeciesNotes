//: [Previous](@previous)

import Cocoa
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely(true)
class myTimer:NSView {
    
    //秒
    var second:NSTimeInterval{
        set{
        }
        get{
            return self.second
        }
    }
    //分
    var minute:NSTimeInterval{
        set(newValue){
        }
        get{
            return self.minute
        }
    }
    var countDownField:NSTextField!
    
    
    
    func fireTimere(CountDown:Double) {
        countDownField = NSTextField.init(frame: CGRectMake(0, 0, 40, 80))
        self.addSubview(countDownField)
        self.minute = CountDown / 60
        self.second = CountDown % 60
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(myTimer.Countdown), userInfo: nil, repeats: true)
    }
    
    @objc func Countdown() {
        countDownField.stringValue = "dddddddd"
        countDownField.stringValue = "\(second) s"
            if (second<0) {
                minute = minute - 1
                second = 60
            }
            if (minute == 0) {
                second = second - 1
                countDownField.stringValue = "\(second)秒"
                //背景色
                if (second < 10) {
                    self.animator().alphaValue = 0.3
                    countDownField.backgroundColor = NSColor.redColor()
                    if (second < 0) {
                        //关闭播放器
                        //                        NSNotificationCenter.defaultCenter().postNotificationName("CancleClosePlayerWindows", object: nil)
                    }
                }
            } else {
                countDownField.stringValue = "\(minute)分\(second)秒"
            }
    }

}

var superView = myTimer.init(frame: CGRectMake(0, 0, 500, 500))
superView.fireTimere(10.0)
//let timer = NSTimer.init(timeInterval: 1.0, target: superView, selector: "Countdown", userInfo: nil , repeats: true)

//NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)



XCPlaygroundPage.currentPage.liveView = superView




//: [Next](@next)
