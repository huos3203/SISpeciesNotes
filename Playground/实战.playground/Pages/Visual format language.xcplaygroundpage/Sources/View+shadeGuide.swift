//
//  View+shadeGuide.swift
//  PBB
//
//  Created by pengyucheng on 16/4/26.
//  Copyright © 2016年 pyc.com.cn. All rights reserved.
//

import UIKit


// MARK: - 扩展UIView添加全屏遮罩
extension UIView{
    
    //
    func addGuideFullScreen(backgroundImageView:UIImageView,leftItem:UIButton,rightItem:UIButton) ->(UIButton)->(){
        //
        self.translatesAutoresizingMaskIntoConstraints = false
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[self]-0-|",
                                                                          options: [],
                                                                          metrics: nil,
                                                                          views: ["self":self])
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[self]-0-|",
                                                                          options: [],
                                                                          metrics: nil,
                                                                          views: ["self":self])
        superview?.addConstraints(vConstraints)
        superview?.addConstraints(hConstraints)
        
        self.addSubview(leftItem)
        self.addSubview(rightItem)
        self.addSubview(backgroundImageView)
        leftItem.translatesAutoresizingMaskIntoConstraints = false
        rightItem.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftItem_Vconstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-29-[leftItem]",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["leftItem":leftItem])
        let leftItem_Hconstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[leftItem]",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["leftItem":leftItem])
        self.addConstraints(leftItem_Hconstraints)
        self.addConstraints(leftItem_Vconstraints)
        
        let rightItem_Vconstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-29-[rightItem]",
                                                                                    options: [],
                                                                                    metrics: nil,
                                                                                    views: ["rightItem":rightItem])
        let rightItem_Hconstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[rightItem]-20-|",
                                                                                    options: [],
                                                                                    metrics: nil,
                                                                                    views: ["rightItem":rightItem])
        self.addConstraints(rightItem_Hconstraints)
        self.addConstraints(rightItem_Vconstraints)
        
        let backgroundImageViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[ImageView]-0-|",
                                                                                  options: [],
                                                                                  metrics: nil,
                                                                                  views: ["ImageView":backgroundImageView])
        let backgroundImageViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[ImageView]-0-|",
                                                                                  options: [],
                                                                                  metrics: nil,
                                                                                  views: ["ImageView":backgroundImageView])
        
        self.addConstraints(backgroundImageViewH)
        self.addConstraints(backgroundImageViewV)
        
        leftItem.addTarget(self.superclass, action: Selector("hiddenGuideItem:"), forControlEvents: .TouchUpInside)
        rightItem.addTarget(self, action: Selector("hiddenGuideItem:"), forControlEvents: .TouchUpInside)

        //嵌套函数，隐藏操作
        func hiddenGuideItem(item:UIButton) {
            //
            item.hidden = true
            if leftItem.hidden && rightItem.hidden {
                //
                self.hidden = true
                self.removeFromSuperview()
            }
        }
        return hiddenGuideItem
    }
    
    
}