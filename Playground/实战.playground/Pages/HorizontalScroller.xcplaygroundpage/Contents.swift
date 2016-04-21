//: [Previous](@previous)

import Foundation
import XCPlayground
import SnapKit


class scroller:UIViewController{
    //添加五张图片，点击后方法，并居中
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        //
        addSubPageView()
    }
    func addSubPageView()->UIScrollView {
        scrollView.pagingEnabled = true
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.left.top.bottom.right.equalTo(view)
        }
        scrollView.backgroundColor = UIColor.yellowColor()
        let tap = UITapGestureRecognizer.init(target:self, action:#selector(scroller.hander(_:)))
        scrollView.addGestureRecognizer(tap)
        
        let images = [[#Image(imageLiteral: "barcelona-thumb@3x.jpg")#],[#Image(imageLiteral: "beijing-thumb@3x.jpg")#],[#Image(imageLiteral: "london-thumb@3x.jpg")#],[#Image(imageLiteral: "walt-disney-world-thumb@3x.jpg")#],[#Image(imageLiteral: "sydney-thumb@3x.jpg")#],[#Image(imageLiteral: "barcelona-thumb@2x.jpg")#]]
        var preView:UIImageView!
        var tag = 0
        for image in images {
            let imageview = UIImageView(image: image)
            tag += 1
            imageview.tag = tag
            print(imageview.tag)
            
            imageview.userInteractionEnabled = true
            scrollView.addSubview(imageview)
            imageview.sizeToFit()
            if (preView != nil) {
                imageview.snp_makeConstraints(closure: { (make) in
                    //
                    make.centerY.equalTo(preView)
                    make.left.equalTo(preView.snp_right)
                    make.height.width.equalTo(200)
                })
            }else{
                //第一个ImageView的约束
                imageview.snp_makeConstraints(closure: { (make) in
                    //
                    make.centerY.equalTo(scrollView)
                    make.left.equalTo(scrollView)
                    make.height.width.equalTo(200)
                })
            }
            
            preView = imageview
        }
        
        //循环结束之后，为最后一个ImageView添加right约束
        preView.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView)
        }
        return scrollView
    }
    
    
    @objc func hander(TapGesture:UITapGestureRecognizer) {
    
        //获取ImageView
        let scrollView = TapGesture.view as! UIScrollView
        let tapPoint = TapGesture.locationInView(scrollView)
        
        for imageView in scrollView.subviews{
            
            if CGRectContainsPoint(imageView.frame, tapPoint) {
                //
                var viewcenter = (view.frame.size.width - 200)/2
                if tapPoint.x < viewcenter {
                    viewcenter = -viewcenter
                }
                let offset = imageView.frame.origin.x + imageView.frame.size.width/2 + viewcenter
                print("点击.\(tapPoint.x)..tag = \(imageView.tag)..offset = \(offset)")
                scrollView.contentOffset = CGPointMake(offset, 0)
            }
        
        }
        
    }
    
    

}

XCPlaygroundPage.currentPage.liveView = scroller()


//: [Next](@next)
