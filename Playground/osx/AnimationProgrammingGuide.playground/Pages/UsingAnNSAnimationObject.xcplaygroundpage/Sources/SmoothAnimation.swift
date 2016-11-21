import Foundation
import AppKit

public class SmoothAnimation:NSAnimation
{
    override public init(duration: TimeInterval, animationCurve: NSAnimationCurve) {
        super.init(duration: duration, animationCurve: animationCurve)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var currentProgress: NSAnimationProgress
    {
        set(newValue){
            var theWinFrame = NSApp.mainWindow?.frame
            let theScreenFrame = NSScreen.main()?.visibleFrame
            theWinFrame?.origin.x = CGFloat(newValue * Float(theScreenFrame!.size.width - theWinFrame!.size.width))
            NSApp.mainWindow?.setFrame(theWinFrame!, display: true, animate: true)
        }
        get{
            return self.currentProgress
        }
    }
    
    override public var runLoopModesForAnimating:[RunLoopMode]?
    {
        return [RunLoopMode.defaultRunLoopMode,RunLoopMode.modalPanelRunLoopMode]
    }
}


