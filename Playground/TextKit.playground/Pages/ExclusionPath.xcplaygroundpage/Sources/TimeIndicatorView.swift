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

    public func updateSize() {
        //
        // size the label based on the font
        timeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        timeLabel.frame = CGRectMake(0, 0, CGFloat.max, CGFloat.max)
        timeLabel.sizeToFit()
        
        // set the frame to be large enough to accomodate circle that surrounds the text
        let radius = radiusToSurroundFrame(timeLabel.frame)
        self.frame = CGRectMake(0, 0, radius*2, radius*2)
        
        // center the label within this circle
        timeLabel.center = self.center
        
        // offset the center of this view to ... erm ... can I just draw you a picture?
        // You know the story - the designer provides a mock-up with some static data, leaving
        // you to work out the complex calculatins required to accomodate the variability of real-world
        // data. C'est la vie!
        let padding = CGFloat(5)
        self.center = CGPointMake(self.center.x + timeLabel.frame.origin.x - padding,
                                  self.center.y - timeLabel.frame.origin.y + padding)
    }
    
    // calculates the radius of the circle that surrounds the label
    func radiusToSurroundFrame(frame:CGRect) -> CGFloat {
        //半径
        return max(frame.size.width, frame.size.height) * 0.5 + 20.0
    }
    
    func curvePathWithOrigin(origin:CGPoint)->UIBezierPath{
    
        //画弧形
        let path = UIBezierPath.init(arcCenter: origin,
                                     radius: radiusToSurroundFrame(timeLabel.frame),
                                     startAngle: 0,
                                     endAngle: CGFloat(M_PI * 2),
                                     clockwise: false)
//        UIColor.blueColor().set()
//        path.fill()
//        UIColor.blueColor().set()
        return path
    }

    
    public override func drawRect(rect: CGRect) {
        
        //Returns the current graphics context.
        let ctx = UIGraphicsGetCurrentContext()
////        Sets anti-aliasing on or off for a graphics context.
////        Anti-aliasing is a graphics state parameter.
        CGContextSetShouldAntialias(ctx, true)
        let path = curvePathWithOrigin(timeLabel.center)
        //填充色
        UIColor.blueColor().setFill()
        path.fill()
        
        //画笔色
//        path.lineWidth = 1.5
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