import Cocoa

extension NSButton
{
    //    A declaration cannot be both 'final' and 'dynamic'
    //    static var stopRotating = false
    static var stopRotating:Bool!
    
    var angle:CGFloat{
        //        set(newValue){
        //        }
        get{
            tag = (tag + 10)
            //将角度转换为弧度
//            let l = CGFloat(Double(tag)*M_PI/180.0)
            
            return CGFloat(tag)
        }
    }
    
    //"transform.rotation":自我为中心，自转
    var groupAnimation:CAAnimationGroup{
        //渐隐渐现
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.duration = 2.0
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT //NSIntegerMax // CGFLOAT_MAX
        animation.fromValue = NSNumber.init(float: 1.0)
        animation.toValue = NSNumber.init(float: 0.0)
        
        //自转动画
        let animation1 = CABasicAnimation.init(keyPath: "transform.rotation")
        animation1.duration = 2.0
        //原路返回动画
        animation1.autoreverses = true
        //重复动画次数
        animation1.repeatCount = MAXFLOAT
        animation1.fromValue = NSNumber.init(double: Double(self.angle))
        animation1.toValue = NSNumber.init(double: Double(self.angle))
        
        let group = CAAnimationGroup.init()
        group.duration = 2.0
        //原路返回的动画一遍
        //group.autoreverses = true
        //重复旋转
        group.repeatCount = MAXFLOAT
        group.animations = [animation1]
        return group
    }
    
    var keyframeAnimation:CAKeyframeAnimation{

        //"transform.rotation":旋转
        let keyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        //CGAffineTransformMakeRotation
        let endAngle = CGAffineTransformMakeRotation(CGFloat(Double(self.angle) * (M_PI/180.0)))
        var transform = CGAffineTransformTranslate(endAngle, 1, 0.6)
        
        //"position":位置移动
//        let keyframeAnimation = CAKeyframeAnimation.init(keyPath: "position")
//        var transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 0.6)
        
        
        let path = CGPathCreateMutable()
        CGPathAddArc(path, &transform, frame.origin.x, frame.origin.y, 70, 0, CGFloat(2 * M_PI), false)
    
        keyframeAnimation.duration = 2
        keyframeAnimation.repeatCount = MAXFLOAT
        keyframeAnimation.path = path
        //CGPathRelease(path)
        return keyframeAnimation
    }
    //"transform.rotation":
    var rotateAnimation:CABasicAnimation{
        let rotateAnimation = CABasicAnimation.init(keyPath: "transform.rotation")
        rotateAnimation.duration = 2.0
//        rotateAnimation.autoreverses = true
        rotateAnimation.repeatCount = MAXFLOAT
        
        //from设置
        //rotateAnimation.fromValue = NSValue.init(CATransform3D: CATransform3DIdentity)
        rotateAnimation.fromValue = self.angle
        
        //to设置
        //let transform = CATransform3DRotate(CATransform3DIdentity, self.angle, 0, 0, 1)
        let transform = CATransform3DMakeRotation(self.angle, 0, 0, -1)
        rotateAnimation.toValue = NSValue.init(CATransform3D: transform)

        return rotateAnimation
    }
   
    
    //"transform.rotation.x":默认底边作轴，公转
    var rotationXAnimation:CABasicAnimation{
        let rotationXAnimation = CABasicAnimation.init(keyPath: "transform.rotation.x")
        rotationXAnimation.duration = 2.0
        rotationXAnimation.autoreverses = true
        rotationXAnimation.repeatCount = MAXFLOAT
        rotationXAnimation.fromValue = NSNumber.init(float: 0)
        rotationXAnimation.toValue = NSNumber.init(double: 2*M_PI)
        return rotationXAnimation
    }
    
    // scale+rotate+position
    var scaleRotatePositionAnimation:CABasicAnimation{
        let anim = CABasicAnimation.init(keyPath: "transform")
        //旋转动画 /1.57表示所转角度的弧度 = 90Pi/180 = 90*3.14/180
        let rotateTransform = CATransform3DMakeRotation(1.57, 0, 0, -1)
        //缩放动画
        let scaleTransform = CATransform3DMakeScale(5, 5, 5)
        //位置移动
        let positionTransform = CATransform3DMakeTranslation(0, 0, 0)
         //Concat就是combine的意思
        var combinedTransform = CATransform3DConcat(rotateTransform, scaleTransform)
        //再combine一次把三个动作连起来
        combinedTransform = CATransform3DConcat(combinedTransform, positionTransform)
        //放在3D坐标系中最正的位置
        anim.fromValue = NSValue.init(CATransform3D: CATransform3DIdentity)
        anim.toValue = NSValue.init(CATransform3D: combinedTransform)
        //动画时长
        anim.duration = 2.0
        //如果没有这句，layer执行完动画又会返回最初的state
        layer?.transform = combinedTransform
        
        return anim
    }

    
    public func startRotate() {
        //设置自我为中心自转动画
        wantsLayer = true
        layer?.anchorPoint = NSMakePoint(0.5, 0.5)
        
        //"transform.rotation":自我为中心
//        layer?.addAnimation(groupAnimation, forKey: "")
        
        layer?.addAnimation(rotateAnimation, forKey: "")
        
        //"transform.rotation.x":底边作轴
        //layer?.addAnimation(rotationXAnimation, forKey: "")
       
        //"rotation":旋转动画 "position":位置移动
//      layer?.addAnimation(keyframeAnimation, forKey: "")

        
        //scale+rotate+position:组合动画
        //layer?.addAnimation(scaleRotatePositionAnimation, forKey: "")
        
        NSButton.stopRotating = false
        //self.rotateRefreshImage(false)
    }
    
    func endUpdating() {
        //
        NSButton.stopRotating = true
        //layer?.removeAllAnimations()
    }
    
    /* http://www.tanhao.me/pieces/702.html/
     * Mac不支持tranform
     let endAngle = CGAffineTransformMakeRotation(CGFloat(NSButton.angle * (M_PI/180.0))) //M_PI
     self.transform = endAngle
     */
    func rotateRefreshImage(isGroup:Bool)
    {
        if !isGroup {
            startGroupAnimation()
        }
        
        //迭代
        if !NSButton.stopRotating {
            rotateRefreshImage(false)
        }
    }
    
    //
    func startGroupAnimation() {
        //        var rotation = self.frameRotation
        //动画组
        NSAnimationContext.runAnimationGroup({ (context) in
            //
            context.duration = 0.05
            self.animator().alphaValue = 1
            //                let rotation = self.frameRotation + 360
            
            
            //自转
            //                self.layer?.anchorPoint = NSMakePoint(0.5, 0.5)
            //                self.animator().translateOriginToPoint(NSZeroPoint)
            //                self.animator().setBoundsOrigin(NSZeroPoint)
            self.animator().frameCenterRotation = self.angle //公转：CGFloat(Double(self.angle) * (M_PI/180.0))
            
            //公转
            //                self.animator().setFrameOrigin(NSZeroPoint)
            //                self.animator().frameRotation = self.angle
            
            //
            //            self.animator().rotateByAngle(self.angle)
            })
        {
            //                NSButton.angle = NSButton.angle + 10
            //                rotation = rotation + 10
            if !NSButton.stopRotating
            {
                self.rotateRefreshImage(true)
            }
        }
    }
}
