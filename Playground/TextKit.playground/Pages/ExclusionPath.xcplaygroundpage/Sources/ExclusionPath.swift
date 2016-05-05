import Foundation
import UIKit


/**
 *  使用textKit实现文本和图片混排，在拖动图片移动时，更新富文本布局
 */

public class ExclusionPath:UIViewController{

    //文本
    private let text = "Text containers: 对应着NSTextContainer类。NSTextContainer定义了文本可以排版的区域。一般来说，都是矩形区域，当然，也可以根据需求，通过子类化NSTextContainer来创建别的一些形状，例如圆形、不规则的形状等。NSTextContainer不仅可以创建文本可以填充的区域，它还维护着一个数组——该数组定义了一个区域，排版的时候文字不会填充该区域，因此，我们可以在排版文字的时候，填充非文本元素。"
    //图片
    private let imageView = UIImageView.init(image: UIImage(named:"barcelona-thumb@2x.jpg"))
    private let textView = UITextView()
    
    //
    private var gestureStartingPoint:CGPoint!
    private var gestureStartingCenter:CGPoint!
    
    override public func viewDidLoad() {
        
        view.addSubview(textView)
        view.addSubview(imageView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        let constaintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textView]-|", options: [], metrics: nil, views: ["textView":textView])
        let constaintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textView]-|", options: [], metrics: nil, views: ["textView":textView])
        view.addConstraints(constaintsV)
        view.addConstraints(constaintsH)
        //添加拖动图片事件
        let pan = UIPanGestureRecognizer.init(target: self, action:#selector(ExclusionPath.imagePanned(_:)))
        //设置图片可交互性
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(pan)
        view.backgroundColor = UIColor.whiteColor()
        
        textView.text = text
        textView.textContainer.exclusionPaths = [createExclusionPaths()]
        
    }

    func createExclusionPaths() -> UIBezierPath {
        //将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
//        let butterflyImageRect = textView.convertRect(imageView.frame, toView: view)
        //// 将rect从view中转换到当前视图中，返回在当前视图中的rect
        let butterflyImageRect = textView.convertRect(imageView.frame, fromView: view)
        let bezierPath = UIBezierPath.init(rect: butterflyImageRect)
        return bezierPath
    }

    func imagePanned(localSender:UIPanGestureRecognizer)  {
        //
        switch localSender.state {
        case .Began:
            //translationInView在指定的坐标系中移动,该方法返回在横坐标上、纵坐标上拖动了多少像素
            gestureStartingPoint = localSender.translationInView(textView)
            gestureStartingCenter = imageView.center
        case .Changed:
            
            let currentPoint = localSender.translationInView(textView)
            //求出偏移量
            let distanceX = currentPoint.x - gestureStartingPoint.x
            let distanceY = currentPoint.y - gestureStartingPoint.y
            
            var newCenter = gestureStartingCenter
            newCenter.x += distanceX
            newCenter.y += distanceY
            
            imageView.center = newCenter
            textView.textContainer.exclusionPaths = [createExclusionPaths()]
            
        case .Ended:
            
            gestureStartingCenter = CGPointZero
            gestureStartingPoint = CGPointZero
        default:
            print("拖动.....")
        }
    }




}

