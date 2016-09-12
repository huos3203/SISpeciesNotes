//: [Previous](@previous)

import Foundation

import Cocoa
import XCPlayground
import SnapKit

class rotateViewController: NSView {
    
    override init(frame frameRect: NSRect) {
        //
        super.init(frame: NSMakeRect(0, 0, 200, 200))
        drawButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let ratateButton = NSButton.init()
    
    func startRotate1() {
        //
        NSLog("-------")
        ratateButton.startRotate()
    }
    
    func drawButton() {
        
        ratateButton.image = [#Image(imageLiteral: "4.png")#]
        ratateButton.sizeToFit()
        addSubview(ratateButton)
        ratateButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        //直接执行点击事件
//        ratateButton.sendAction("startRotate1", to: self)
        //添加点击事件
        ratateButton.target = self
        #if swift (>=2.2)
            //方法1
            ratateButton.action = #selector(startRotate1) // now it autocompletes!
            //方法2
            //ratateButton.action = #selector(rotateViewController.startRotate1)
        #else
            ratateButton.action = "startRotate1:" //old way to do it in swift
        #endif
        
    }


}

XCPlaygroundPage.currentPage.liveView = rotateViewController()








//: [Next](@next)
