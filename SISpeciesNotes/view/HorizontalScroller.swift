//
//  HorizontalScroller.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/21.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import UIKit
import SnapKit

 /// 制作一个通用的侧滑滚动scrollView，适配器模块可以仿照tableview定义协议方法的方式，暴露部分定制接口(即委托方法)，由委托类根据自身特征及需求来实现接口方法(委托方法)，以完成定制操作，得到各具特色的滚动控件
//委托方式弥补了单继承的缺陷，从而一个类即可拥有多个委托类的功能

//定义协议，暴露委托方法
@objc public protocol HorizontalScrollerDelegate{
    
    //actionDelegate
    func onclickPageImageView(_ imageView:UIView)
}

@objc public protocol HorizontalScrollerDataSource {

    //滚动图片的个数
    var pageNumOfScroller:Int{get}
    
    var currentImageIndex:Int{get set}
    
    
    func horizontalScroller(_ scroller:UIScrollView ,imageViewIndex:Int)->UIView
}


//适配器：通过委托方式来实现适配器模式
open class HorizontalScroller: UIView {
    
    fileprivate var imgWidth:CGFloat = 200
    fileprivate var imgPadding:CGFloat = 0
    //weak 定义委托
    open weak var scrollerDelegate:HorizontalScrollerDelegate?
    open weak var scrollerDataSource:HorizontalScrollerDataSource?
    //scrollview对象
    let scrollView = UIScrollView()
    
    open func initScrollView(_ imgWidth:CGFloat,imgPadding:CGFloat) {

        self.imgWidth = imgWidth
        self.imgPadding = imgPadding
        
        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.blue
        backgroundColor = UIColor.black
        scrollView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self).inset(8)
        }
        //
        scrollView.alwaysBounceHorizontal = true
        //拖动时锁定方向
        scrollView.isDirectionalLockEnabled = true
        addSubPageView()
        centerCurrentImageView(true)
    }
    
    //添加五张图片
    fileprivate func addSubPageView() {
        //向scrollview中添加操作
        var preView:UIView!
        guard let pageNum = scrollerDataSource?.pageNumOfScroller else
        {
            print("图片为0张")
            return
        }
        
        for index in 0..<pageNum {
            print("添加第：\(index)个图片")
            let imageview = scrollerDataSource?.horizontalScroller(scrollView,imageViewIndex: index)
            scrollView.addSubview(imageview!)
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(HorizontalScroller.tapImageAction(_:)))
            imageview?.isUserInteractionEnabled = true
            imageview?.addGestureRecognizer(tapGesture)
            if (preView != nil) {
                imageview!.snp_makeConstraints({ (make) in
                    //
                    make.centerY.equalTo(preView)
                    make.left.equalTo(preView.snp_right).offset(imgPadding)
                    make.size.equalTo(preView)
                })
            }else{
                //第一个ImageView的约束
                imageview!.snp_makeConstraints({ (make) in
                    /**
                     *  当有导航控制器时，由于scrollview默认偏移量是导航条的高度，此时make.centerY.equalTo(scrollView)会导致轮初始化轮播图默认位置偏下方，可以添加.offset(-65)
                        更好的解决办法是：轮播图与scrollView父视图垂直居中对齐： make.centerY.equalTo(self)
                     */
                    make.centerY.equalTo(self)
                    make.left.equalTo(scrollView).offset(imgPadding)
                    make.size.equalTo(CGSize(width: imgWidth, height: imgWidth))
                })
            }
            preView = imageview
        }
        
        //循环结束之后，为最后一个ImageView添加right约束
        preView.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView).offset(imgPadding)
        }
    }
    
    //点击后，自动居中显示
    func tapImageAction(_ tapGesture:UITapGestureRecognizer) {
        //获取当前Image
        print("点击图片....")
        let imageView = tapGesture.view!
        scrollerDelegate?.onclickPageImageView(imageView)
        let offset = imageView.frame.origin.x + (imageView.frame.size.width/2 - self.frame.size.width/2)
        scrollView.setContentOffset(CGPoint(x: offset,y: 0), animated: true)
    }
}

extension HorizontalScroller:UIScrollViewDelegate{
    
    //实现侧滑停止后，居中显示当前屏幕上的图片
    func centerCurrentImageView(_ initScroller:Bool){
        
        //先通过偏移量算出屏幕中心点的 x 坐标
        let current_x = scrollView.contentOffset.x + scrollView.frame.size.width/2
        //再通过中心点 X 坐标，算出当前居中位置的图片索引,确定居中图片对象
        var imageIndex = Int(current_x/(imgWidth+imgPadding))
        if initScroller {
            //
            imageIndex = (scrollerDataSource?.currentImageIndex)!
        }else
        {
            imageIndex = Int(current_x/(imgWidth+imgPadding))
            scrollerDataSource?.currentImageIndex = imageIndex
        }
        //根据图片origin.x + width/2 算出即将居中的x坐标
        let replace_x = scrollView.subviews[imageIndex].frame.origin.x + imgWidth/2
        //根据当前屏幕中心的x 坐标，和即将居中的x坐标点,求出坐标差，
        let space_x = replace_x - current_x
        //当前偏移量 + (当前图片中心坐标 - 原中心x)
        let offset = scrollView.contentOffset.x + space_x
        
        print("当前坐标:\(current_x),图片索引：\(imageIndex)和中心坐标：\(replace_x)\n偏移量：\(space_x)")
        scrollView.setContentOffset(CGPoint(x: CGFloat(offset), y: 0), animated: true)
    }
    
    //侧滑结束
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //
        centerCurrentImageView(false)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //
        if !decelerate {
            centerCurrentImageView(false)
        }
    }
}








