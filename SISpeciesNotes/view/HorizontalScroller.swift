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
//    weak var scrollerDelegate:HorizontalScrollerDelegate?
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
        addSubPageView()
    }
    
    //添加五张图片
    func addSubPageView() {
        
        let imageview1 = UIImageView(image: UIImage(named: "barcelona-thumb"))
        let imageview2 = UIImageView(image: UIImage(named: "beijing-thumb"))
        let imageview3 = UIImageView(image: UIImage(named: "denali-national-park-and-preserve-thumb"))
        let imageview4 = UIImageView(image: UIImage(named: "walt-disney-world-thumb"))
        let imageview5 = UIImageView(image: UIImage(named: "sydney-thumb"))
//        let pages = [imageview1,imageview2,imageview3,imageview4,imageview5]
        //向scrollview中添加操作
        scrollView.addSubview(imageview1)
        scrollView.addSubview(imageview2)
        scrollView.addSubview(imageview3)
        scrollView.addSubview(imageview4)
        scrollView.addSubview(imageview5)
        imageview1.snp_makeConstraints { (make) in
            //
            make.left.top.bottom.equalTo(scrollView)
        }

        imageview2.snp_makeConstraints { (make) in
            //
            make.centerY.equalTo(imageview1)
            make.left.equalTo(imageview1.snp_right)
        }
        
        imageview3.snp_makeConstraints { (make) in
            //
            make.centerY.equalTo(imageview2)
            make.left.equalTo(imageview2.snp_right)
        }
        
        imageview4.snp_makeConstraints { (make) in
            //
            make.centerY.equalTo(imageview3)
            make.left.equalTo(imageview3.snp_right)
        }
        imageview5.snp_makeConstraints { (make) in
            //
            make.centerY.equalTo(imageview4)
            make.left.equalTo(imageview4.snp_right)
            make.right.equalTo(scrollView.snp_left)
        }
    }
}












