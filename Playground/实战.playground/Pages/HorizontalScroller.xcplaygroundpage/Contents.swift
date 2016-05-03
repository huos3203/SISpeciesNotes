//: [Previous](@previous)

import Foundation
import XCPlayground
import SnapKit

import SISFramework

class scroller:UIViewController{
    //添加五张图片，点击后方法，并居中
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        //
        addSubPageView()
    }
    func addSubPageView()->UIScrollView {
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
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
                //scrollview偏移量 ＝ 当前位置 + (屏幕width - 图片width)
                scrollView.setContentOffset(CGPointMake(imageView.frame.origin.x - view.frame.size.width/2 + imageView.frame.size.width/2, 0), animated:true)
            }
        
        }
        
    }
    
    func centerCurrentViewbyTap(localPoint:CGPoint)->CGFloat  {
        //
        //二元方程式：求第N张图片，在ScrollView中心显示
        //1. 中心坐标xFinal = 偏移量 + 图片宽度/2 + 图片间距
        //2. 第N张 ＝ 中心坐标xFinal/(图片宽度 + 2 * 图片间距)
        //3. xFinal = 第N张 *
        let CenterX = scrollView.contentOffset.x + view.frame.size.width/2
        
        print("\(view.frame.size.width/2)|||||\(CenterX)-----\(localPoint.x) ===\(CenterX - localPoint.x)")
        let offset = scrollView.contentOffset.x - (CenterX - localPoint.x)
        
//        if localPoint.x < CenterX {
//            //向右移动
//            offset = scrollView.contentOffset.x - CenterX - localPoint.x
//        }else
//        {
//            //向左移动
//            offset = scrollView.contentOffset.x + localPoint.x - CenterX
//        }
       print("偏移量：\(offset)")
        return   offset
    }
    
    //滑动居中
    func centerCurrentViewByScroll(localPoint:CGPoint)->CGFloat  {
        //
        //二元方程式：求第N张图片，在ScrollView中心显示
        //1. 中心坐标xFinal = 偏移量 + 图片宽度/2 + 图片间距
        //2. 第N张 ＝ 中心坐标xFinal/(图片宽度 + 2 * 图片间距)
        //3. xFinal = 第N张 *
        var xFinal = scrollView.contentOffset.x + 100
        let viewIndex = xFinal / 200
        xFinal = viewIndex * 200
        return xFinal
    }

}

extension scroller:UIScrollViewDelegate{
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        //
        print("完成偏移动画:\(scrollView.contentOffset.x)")
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //
         print("完成偏移动画1111:\(scrollView.contentOffset.x)")
    }

}

//XCPlaygroundPage.currentPage.liveView = scroller()

class horizontalScrollViewController:UIViewController{

    let scrollView = HorizontalScroller()
    var images:[UIImage]?
    override func viewDidLoad() {
        //
        view.backgroundColor = UIColor.whiteColor()
        images = [[#Image(imageLiteral: "barcelona-thumb@3x.jpg")#],[#Image(imageLiteral: "beijing-thumb@3x.jpg")#],[#Image(imageLiteral: "london-thumb@3x.jpg")#],[#Image(imageLiteral: "walt-disney-world-thumb@3x.jpg")#],[#Image(imageLiteral: "sydney-thumb@3x.jpg")#],[#Image(imageLiteral: "barcelona-thumb@2x.jpg")#]]
        scrollView.scrollerDelegate = self
        scrollView.scrollerDataSource = self
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.height.equalTo(100)
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(40)
//            make.top.equalTo(view).offset(80)
            make.left.right.equalTo(view)

            //            make.edges.equalTo(view).inset(UIEdgeInsetsMake(20, 20, 20, 20))
        }
        scrollView.initScrollView()
        
     
    }
}

extension horizontalScrollViewController:HorizontalScrollerDelegate{
    func onclickPageImageView(imageView: UIView) {
        print("点击图片....")
    }

}

extension horizontalScrollViewController:HorizontalScrollerDataSource{
    
    func pageNumOfScroller() -> Int {
        print("图片个数：.....")
        return 5
    }
    
    func horizontalScroller(scroller:UIScrollView ,imageViewIndex: Int) -> UIView {
        //
        let imageView = UIImageView(image: images![imageViewIndex])
        let view = UIView()
        view.addSubview(imageView)
        return view
    }

}
/**
 当有导航控制器时，由于scrollview默认偏移量是导航条的高度，此时make.centerY.equalTo(scrollView)会导致轮初始化轮播图默认位置偏下方，可以添加.offset(-65)
 更好的解决办法是：轮播图与scrollView父视图垂直居中对齐： make.centerY.equalTo(self)
 */
//XCPlaygroundPage.currentPage.liveView = horizontalScrollViewController()
let nav = UINavigationController.init(rootViewController: horizontalScrollViewController())
XCPlaygroundPage.currentPage.liveView = nav



//: [Next](@next)
