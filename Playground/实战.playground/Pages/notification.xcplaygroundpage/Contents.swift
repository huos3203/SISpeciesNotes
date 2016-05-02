//: [Previous](@previous)

import Foundation
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

class senderNotification
{
    init(){
        print("发出广播...")
    NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self)
    }


}

class getNotification {
    //
    init(){
        print("初始化接收广播....")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "DownloadImage:", name: "BLDownloadImageNotification", object: nil)
    }
    
    func DownloadImage(notification:NSNotification) {
        //
        print("成功接收广播...")
    }
}

senderNotification()
//senderNotification.setNotification()
getNotification()

//: [Next](@next)
