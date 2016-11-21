//
//  CustomAnimation.swift
//  TextKitNotepad
//
//  Created by huoshuguang on 2016/11/21.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Cocoa
import AppKit

class CustomAnimation:NSViewController,NSAnimationDelegate
{
    var theAnim:NSAnimation!
    //想在构造器中使用self指定为其他协议的代理，必须先执行super.init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("创建一个动画对象...")
        //NSAnimation:触发播放音乐
        //SmoothAnimation:执行窗口从屏幕左->右平滑飘过的动画效果
        theAnim = SmoothAnimation.init(duration: 30.0,
                                       animationCurve: .easeInOut)
        theAnim.frameRate = 200.0
        theAnim.animationBlockingMode = .nonblockingThreaded //子线程动画
        theAnim.delegate = self
        
        let progMarks:[NSAnimationProgress] = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0]
        
        let count = 20
        
        for i in 0..<count {
            //
            print("\(progMarks[i])")
            //兵马未动粮草先行，上满堂子弹，在执行动画开始，全部突突突出节奏感
            theAnim.addProgressMark(progMarks[i])
        }
    }
    override func viewDidLoad()
    {
    }
    /*
     awakeFromNib两次被调用：
        一次从Storyboard加载时被调用
        一次在执行重写构造器init?(coder: NSCoder)后被调用
     */
    override func awakeFromNib() {
        //
        print("---awakeFromNib---")
        let progMarks:[NSAnimationProgress] = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0]
        
        let count = 20
        
        for i in 0..<count {
            //
            print("\(progMarks[i])")
            //兵马未动粮草先行，上满堂子弹，在执行动画开始，全部突突突出节奏感
            theAnim.addProgressMark(progMarks[i])
        }
    }
    
    
    @IBAction func ibaStartAnim(_ sender: Any)
    {
        print("start\(theAnim.currentProgress)")
        theAnim.start()
    }

    @IBAction func ibaStopAnim(_ sender: Any)
    {
        theAnim.stop()
    }
    
    //addProgressMark(1.0)方法：当mark大于等于1.0时触发结束通知协议
    //当SmoothAnimation重写了currentProgress计算属性，该协议会失效不被执行
    func animation(_ animation: NSAnimation, didReachProgressMark progress: NSAnimationProgress)
    {
        if animation == theAnim
        {
            //progress是耗损弹药的量，可据此更新UI状态进度等
            print("播放音乐\(progress)")
            NSSound.init(named: "ddd.mp3")?.play()
        }
    }
}

class SmoothAnimation:NSAnimation
{
    override init(duration: TimeInterval, animationCurve: NSAnimationCurve)
    {
        super.init(duration: duration, animationCurve: animationCurve)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var currentProgress: NSAnimationProgress
    {
        set(newValue){
            print("currentProgress:\(newValue)")
            var theWinFrame = NSApp.mainWindow?.frame
            let theScreenFrame = NSScreen.main()?.visibleFrame
            theWinFrame?.origin.x = CGFloat(newValue * Float(theScreenFrame!.size.width - theWinFrame!.size.width))
            NSApp.mainWindow?.setFrame(theWinFrame!, display: true, animate: true)
        }
        get{
            print("--currentProgress = 永远0.0---")
            //范围在0.0 ~ 1.0(<=1.0时)，以返回值为起始值：0.0
            return 0.0
        }
    }
    
    override var runLoopModesForAnimating:[RunLoopMode]?
    {
        return [RunLoopMode.defaultRunLoopMode,RunLoopMode.modalPanelRunLoopMode]
    }
}
