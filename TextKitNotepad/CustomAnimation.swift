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
    //重写init?(coder: NSCoder)会导致IBOutlet属性为空
    @IBOutlet weak var firstView: NSView!
    @IBOutlet weak var secondView: NSView!
    var theViewAnim:NSViewAnimation!
    
    var theAnim:NSAnimation!
    var theOtherAnim:SmoothAnimation!
    
    /*
     想在构造器中使用self指定为其他协议的代理，必须先执行super.init
     注：重写init?(coder: NSCoder)会导致IBOutlet属性为空
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
     */
    override func viewDidLoad()
    {
        print("创建一个动画对象...")
        //NSAnimation:触发播放音乐
        theAnim = NSAnimation.init(duration: 30.0,
                                   animationCurve: .easeInOut)
        theAnim.frameRate = 200.0
        //用blocking模式：nonblockingThreaded 动画在主线程里以循环方式接受用户输入
        theAnim.animationBlockingMode = .nonblockingThreaded
        theAnim.delegate = self
        
        //SmoothAnimation:执行窗口从屏幕左->右平滑飘过的动画效果
        theOtherAnim = SmoothAnimation.init(duration: 30.0,
                                            animationCurve: .easeIn)
        theOtherAnim.delegate = self
        theOtherAnim.animationBlockingMode = .nonblockingThreaded //子线程动画
        
        //添加NSViewAnimation
        addViewAnimation()
        //创建复合动画组
        theOtherAnim.start(when: theAnim, reachesProgress: 0.5)
        theViewAnim.start(when: theAnim, reachesProgress: 0.7)
    }
    /*
     awakeFromNib两次被调用：
        先执行：从Storyboard加载时被调用
        后执行：在执行重写构造器init?(coder: NSCoder)后被调用
     注：重写init?(coder: NSCoder)会导致IBOutlet属性为空
     */
    override func awakeFromNib() {
        print("---awakeFromNib---")
    }
    
    override func viewDidAppear()
    {
        //
        let count = 20
        let progMarks:[NSAnimationProgress] = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0]
        for i in 0..<count {
            //
            print("\(progMarks[i])")
            //兵马未动粮草先行，上满堂子弹，在执行动画开始，全部突突突出节奏感
            theAnim.addProgressMark(progMarks[i])
            //重载currentProgress之后的动画进度无效
            theOtherAnim.addProgressMark(progMarks[i])
        }
    }
    
    @IBAction func ibaStartAnim(_ sender: Any)
    {
        print("启动复合动画：\(theAnim.currentProgress)")
        theOtherAnim.start()
    }

    @IBAction func ibaStopAnim(_ sender: Any)
    {
        theAnim.stop()
    }
    
    /*
        addProgressMark(1.0)方法：当mar有变动就会触发通知协议，
         以下两种情况列外：
          1. 当SmoothAnimation重写了currentProgress计算属性，该协议会失效不被执行
          2. 创建复合动画组start(when: reachesProgress:)其中when:参数，即第一动画不能是重载动画的计算属性currentProgress，否则无法启动第二个动画。
     */
    func animation(_ animation: NSAnimation, didReachProgressMark progress: NSAnimationProgress)
    {
        if animation == theAnim
        {
            //progress是耗损弹药的量，可据此更新UI状态进度等
            print("播放音乐动画：\(progress)")
            NSSound.init(named: "ddd.mp3")?.play()
            
        }
        else if animation == theOtherAnim
        {
            //移动动画
            print("屏幕上移动动画1111：\(progress)")
        }
    }
    
    /*
        MARK: - NSViewAnimation动画
        使用连动动画开启动画：theViewAnim.start(when: theAnim, reachesProgress: 0.7)
     */
    func addViewAnimation()
    {
        let firstViewFrame = firstView.frame
        //动画结束位置
        var newViewFrame = firstViewFrame
        newViewFrame.origin.x = newViewFrame.origin.x + 50
        newViewFrame.origin.y = newViewFrame.origin.y + 50
        //指定要修改的视图
        let firstViewDict = [NSViewAnimationTargetKey:firstView,
                          NSViewAnimationStartFrameKey:NSValue.init(rect: firstViewFrame),
                           NSViewAnimationEndFrameKey:NSValue.init(rect: newViewFrame)
        ]
        
        //
        var viewZeroSize = secondView.frame
        viewZeroSize.size.width = 0.0
        viewZeroSize.size.height = 0.0
        let secondViewDict:[String:Any] = [NSViewAnimationTargetKey:secondView,  //将目标对象设置为第二视图
                                      NSViewAnimationEndFrameKey:NSValue.init(rect: viewZeroSize),  //将视图从当前的大小缩小到没有
                                        NSViewAnimationEffectKey:NSViewAnimationFadeOutEffect  //设置淡出特效
            
        ]
        
        theViewAnim = NSViewAnimation.init(viewAnimations: [firstViewDict,secondViewDict])
        theViewAnim.duration = 1.5
        theViewAnim.animationCurve = .easeIn
//                theViewAnim.start()
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
            print("屏幕上移动动画:\(newValue)")
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
    
    /*
     在运行动画之前，动画对象会发送给自己一个runloopmodesforanimation消息，来获取当前有效的运行循环模式：
        1. defaultRunLoopMode:
        2. modalPanelRunLoopMode:模态面板循环模式
        3. eventTrackingRunLoopMode:事件跟踪循环模式
     */
    override var runLoopModesForAnimating:[RunLoopMode]?
    {
        return [RunLoopMode.defaultRunLoopMode,RunLoopMode.modalPanelRunLoopMode,RunLoopMode.eventTrackingRunLoopMode]
    }
}
