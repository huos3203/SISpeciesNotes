import Foundation

//直接绘制到图层的方法由于并非UIKit直接调用因此只能用原生的Core Graphics方法绘制。

/*
 图层绘图有两种方法，不管使用哪种方法绘制完必须调用图层的setNeedDisplay方法（注意是图层的方法，不是UIView的方法，前面我们介绍过UIView也有此方法）
 
 通过图层代理drawLayer: inContext:方法绘制
 通过自定义图层drawInContext:方法绘制
 
 */

import UIKit

/// 绘制圆形图片和边框阴影
public class DrawRoundPhoto:UIViewController{

    let photoHeight:CGFloat = 100
    public override func viewDidLoad() {
        //
        
        drawPhotoLayer()
        DrawShadowLayer()
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    //绘制容器图层
    func drawPhotoLayer()  {
        
        //新建图层
        let photoLayer = CALayer()
        //设置图层属性
        //位置大小
        photoLayer.bounds = CGRectMake(0, 0, photoHeight, photoHeight)
        photoLayer.position = CGPointMake(199, 199)
        //圆形
        photoLayer.cornerRadius = photoHeight/2
        //边框
        photoLayer.borderColor = UIColor.whiteColor().CGColor
        photoLayer.borderWidth = 2
        
        
        //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
        //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
        //原因：原因就是当绘制一张图片到图层上的时候会重新创建一个图层添加到当前图层，这样一来如果设置了圆角之后虽然底图层有圆角效果，但是子图层还是矩形，只有设置了masksToBounds为YES让子图层按底图层剪切才能显示圆角效果。同样的，有些朋友经常在网上提问说为什么使用UIImageView的layer设置圆角后图片无法显示圆角，只有设置masksToBounds才能出现效果，也是类似的问题。
        photoLayer.masksToBounds = true
        
        //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
        //而阴影效果刚好在外边框
        //    layer.shadowColor=[UIColor grayColor].CGColor;
        //    layer.shadowOffset=CGSizeMake(2, 2);
        //    layer.shadowOpacity=1;
        
        //添加到根图层
        view.layer.addSublayer(photoLayer)
        //实现图层协议
        photoLayer.delegate = self
        
        //图层方法，否则不执行协议方法
        photoLayer.setNeedsDisplay()
    }
    
    
    //绘制阴影图层
    func DrawShadowLayer() {
        //
        let shadowLayer = CALayer()
        //位置大小
        shadowLayer.bounds = CGRectMake(0, 0, photoHeight, photoHeight)
        shadowLayer.position = CGPointMake(199, 199)
        //圆形
        shadowLayer.cornerRadius = photoHeight/2
        //边框颜色粗细
        shadowLayer.borderWidth = 2
        shadowLayer.borderColor = UIColor.whiteColor().CGColor
        
        //阴影
        shadowLayer.shadowColor = UIColor.darkGrayColor().CGColor
        shadowLayer.shadowOffset = CGSizeMake(2,1)
        shadowLayer.shadowOpacity = 1
        
        
        //添加到根层
        view.layer.addSublayer(shadowLayer)
    }
    /**
     绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
     
     - parameter layer: photoLayer
     - parameter ctx:   ctx
     */
    public override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        //把图片绘制到图层中
        //开始
        CGContextSaveGState(ctx)
        
        //图片倒立问题的解决办法：
        //方法1:利用 图层形变 解决图像倒立问题
        //        layer.transform=CATransform3DMakeRotation(M_PI, 1, 0, 0)
        //方法2：设置内容contents（注意这里一定要转换为CGImage），不牵涉到绘图也就没有倒立的问题
            // let image=UIImage.init(named: "photo.jpg")
            // layer.contents= image.CGImage
        
        //方法3：
        CGContextScaleCTM(ctx, 1, -1)
        CGContextTranslateCTM(ctx, 0, -photoHeight)
        
        //绘制图片,//注意这个位置是相对于图层而言的不是屏幕
        let photo = UIImage.init(named: "photo.jpg")
        CGContextDrawImage(ctx, CGRectMake(0, 0, photoHeight, photoHeight), photo?.CGImage)
        
        //保存绘制
        CGContextRestoreGState(ctx)
        
    }

}