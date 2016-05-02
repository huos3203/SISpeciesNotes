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
    func onclickPageImageView(imageView:UIView)
}

@objc public protocol HorizontalScrollerDataSource {

    //滚动图片的个数
    func pageNumOfScroller() -> Int
    
    func horizontalScroller(scroller:UIScrollView ,imageViewIndex:Int)->UIView
}


//适配器：通过委托方式来实现适配器模式
public class HorizontalScroller: UIView {
    
    let imgWidth = 100
    let imgPadding = 0
    //weak 定义委托
    public weak var scrollerDelegate:HorizontalScrollerDelegate?
    public weak var scrollerDataSource:HorizontalScrollerDataSource?
    //scrollview对象
    let scrollView = UIScrollView()
    
    public func initScrollView() {

        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.blueColor()
        scrollView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        //
        scrollView.alwaysBounceHorizontal = true
        //拖动时锁定方向
        scrollView.directionalLockEnabled = true
        addSubPageView()
    }
    
    //添加五张图片
    private func addSubPageView() {
        //向scrollview中添加操作
        var preView:UIView!
        guard let pageNum = scrollerDataSource?.pageNumOfScroller() else
        {
            print("图片为0张")
            return
        }
        
        for index in 0..<pageNum {
            print("添加第：\(index)个图片")
            let imageview = scrollerDataSource?.horizontalScroller(scrollView,imageViewIndex: index)
            scrollView.addSubview(imageview!)
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(HorizontalScroller.tapImageAction(_:)))
            imageview?.userInteractionEnabled = true
            imageview?.addGestureRecognizer(tapGesture)
            if (preView != nil) {
                imageview!.snp_makeConstraints(closure: { (make) in
                    //
                    make.centerY.equalTo(preView)
                    make.left.equalTo(preView.snp_right)
                    make.size.equalTo(CGSizeMake(100, 100))
                })
            }else{
                //第一个ImageView的约束
                imageview!.snp_makeConstraints(closure: { (make) in
                    //
                    make.centerY.equalTo(scrollView).offset(-65)
                    make.left.equalTo(scrollView)
                    make.size.equalTo(CGSizeMake(100, 100))
                })
            }
            preView = imageview
        }
        
        //循环结束之后，为最后一个ImageView添加right约束
        preView.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView)
        }
    }
    
    //点击后，自动居中显示
    func tapImageAction(tapGesture:UITapGestureRecognizer) {
        //获取当前Image
        print("点击图片....")
        let imageView = tapGesture.view!
        scrollerDelegate?.onclickPageImageView(imageView)
        let offset = imageView.frame.origin.x + (imageView.frame.size.width/2 - self.frame.size.width/2)
        scrollView.setContentOffset(CGPointMake(offset,0), animated: true)
    }
}

extension HorizontalScroller:UIScrollViewDelegate{
    
    //实现侧滑停止后，居中显示当前屏幕上的图片
    func centerCurrentImageView(){
        
        //先通过偏移量算出屏幕中心点的 x 坐标
        let current_x = scrollView.contentOffset.x + scrollView.frame.size.width/2
        //再通过中心点 X 坐标，算出当前居中位置的图片索引,确定居中图片对象
        let imageIndex = Int(current_x)/(imgWidth+imgPadding)
        //根据图片origin.x + width/2 算出即将居中的x坐标
        let replace_x = Int(scrollView.subviews[imageIndex].frame.origin.x) + imgWidth/2
        //根据当前屏幕中心的x 坐标，和即将居中的x坐标点,求出坐标差，
        let space_x = replace_x - Int(current_x)
        //当前偏移量 + (当前图片中心坐标 - 原中心x)
        let offset = scrollView.contentOffset.x + CGFloat(space_x)
        
        print("当前坐标:\(current_x),图片索引：\(imageIndex)和中心坐标：\(replace_x)\n偏移量：\(space_x)")
        scrollView.setContentOffset(CGPointMake(CGFloat(offset), scrollView.contentOffset.y), animated: true)
    }
    
    //侧滑结束
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //
        centerCurrentImageView()
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //
        if !decelerate {
            centerCurrentImageView()
        }
    }
}








