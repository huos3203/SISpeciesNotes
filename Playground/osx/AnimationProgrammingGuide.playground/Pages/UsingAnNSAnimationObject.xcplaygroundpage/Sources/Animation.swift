import Foundation
import AppKit

public class CustomAnimation:NSViewController,NSAnimationDelegate
{
    var theAnim:NSAnimation!
    public override func viewDidLoad() {
        //
        print("创建一个动画对象")
        theAnim = SmoothAnimation.init(duration: 10.0,
                                       animationCurve: .easeIn)
        theAnim.frameRate = 20.0
        theAnim.animationBlockingMode = .blocking
        theAnim.delegate = self
        //
        theAnim.start()
    }
    public override func awakeFromNib() {
        //
        print("开始动画。。。")
        //
        let textLabel = NSTextField.init(string:"dddddddddddddd")
        view.addSubview(textLabel)
        
        let progMarks:[NSAnimationProgress] = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0]
        
        let count = 20
        
        for i in 0...count {
            //
            print("\(progMarks[i])")
            theAnim.addProgressMark(progMarks[i])
        }

    }
    
    
    public func startAnim()
    {
        theAnim.start()
    }
    
    public func stopAnim()
    {
        //
        theAnim.stop()
    }
    
    //动画结束通知协议
    public func animation(_ animation: NSAnimation, didReachProgressMark progress: NSAnimationProgress) {
        //
        if animation == theAnim
        {
            //
            print("播放5s音乐")
            NSSound.init(named: "ddd.mp3")?.play()
        }
    }
}
