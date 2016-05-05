import Foundation

import UIKit



public class TimeIndicatorView: UIView {
    
    //Label
    private var timeLabel:UILabel!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public init(time:NSDate){
    
        super.init(frame:CGRectMake(0, 0, 100, 100))
        backgroundColor = UIColor.yellowColor()
        clipsToBounds = false
        
        timeLabel = UILabel()
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.numberOfLines = 0
//        timeLabel.textColor = UIColor.blackColor()
        timeLabel.text = time.timeFormatBy("dd\rMMMM\ryyyy")
        timeLabel.sizeToFit()
        
        addSubview(timeLabel)
    }

    func radiusToSurroundFrame(frame:CGRect) -> CGFloat {
        //
        return max(frame.size.width, frame.size.height) * 0.5 + 20.0
    }
    
    func curvePathWithOrigin(origin:CGPoint)->UIBezierPath{
    
        let path = UIBezierPath.init(arcCenter: origin,
                                     radius: radiusToSurroundFrame(timeLabel.frame),
                                     startAngle: 180,
                                     endAngle: -180,
                                     clockwise: true)
//        UIColor.blueColor().set()
//        path.fill()
//        UIColor.blueColor().set()
        return path
    }

    
    public override func drawRect(rect: CGRect) {
        
        //Returns the current graphics context.
        let ctx = UIGraphicsGetCurrentContext()
//        Sets anti-aliasing on or off for a graphics context.
//        Anti-aliasing is a graphics state parameter.
        CGContextSetShouldAntialias(ctx, true)
        let path = curvePathWithOrigin(timeLabel.center)
        //填充色
        UIColor.blueColor().setFill()
        path.lineWidth = 1.5
        path.fill()
        
        //画笔色
//        UIColor.redColor().set()
//        path.stroke()
    }
}

extension NSDate{

    func timeFormatBy(format:String) -> String {
        //
        let timeFormat = NSDateFormatter()
        timeFormat.dateFormat = format
        return timeFormat.stringFromDate(self)
    }
}