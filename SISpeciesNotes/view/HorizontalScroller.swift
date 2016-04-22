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
@objc protocol HorizontalScrollerDelegate{
    
    
    //datasource
    //滚动图片的个数
    func pageNumOfScroller() -> Int
    
    //滚动图片的
    
    //actionDelegate
    func onclickPageImage(image:UIImage)
    
    
}

//适配器：通过委托方式来实现适配器模式
public class HorizontalScroller: UIView {
    
//    var pageNum:Int = 4
//    var pageWidth:Int = 320
//    //weak 定义委托
    weak var scrollerDelegate:HorizontalScrollerDelegate?
    //scrollview对象
    let scrollView = UIScrollView()
    
    
    public func initScrollView() {
        
//        pageNum = (scrollerDelegate?.pageNumOfScroller())!
        addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        //
        scrollView.alwaysBounceHorizontal = true
        //拖动时锁定方向
        scrollView.directionalLockEnabled = true
        addSubPageView([String]())
    }
    
    //添加五张图片
    func addSubPageView(images:[String]) {
        //向scrollview中添加操作
        var preView:UIImageView!
        for image in images {
            let imageview = UIImageView(image: UIImage(named: image))
            scrollView.addSubview(imageview)
            if (preView != nil) {
                imageview.snp_makeConstraints(closure: { (make) in
                    //
                    make.centerY.equalTo(preView)
                    make.left.equalTo(preView.snp_right)
                })
            }else{
                //第一个ImageView的约束
                imageview.snp_makeConstraints(closure: { (make) in
                    //
                    make.centerY.equalTo(scrollView)
                    make.left.top.bottom.equalTo(scrollView)
                })
            }
            preView = imageview
        }
        
        //循环结束之后，为最后一个ImageView添加right约束
        preView.snp_makeConstraints { (make) in
            make.right.equalTo(scrollView)
        }
    }
}









