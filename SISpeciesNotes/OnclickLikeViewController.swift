//
//  OnclickLikeViewController.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/15.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import UIKit
import SnapKit

class OnclickLikeViewController: UIViewController
{
    //签到按钮switch
    let qdSwitch = UISwitch()
    //签到计数
    let count = UILabel()
    
    //测试按钮：expectationForPredicate
    let button = UIButton()
    
    override func viewDidLoad() {
        //加载UI
        addViewInSuperView()
    }
    
    
    //添加点赞按钮，点赞次数,并布局
    func addViewInSuperView()
    {
        //签到Label
        let qdLabel = UILabel()
        qdLabel.text = "签到:"
        view.addSubview(qdLabel)
        
        qdSwitch.on = false
        view.addSubview(qdSwitch)
        
        //签到次数
        let countLabel = UILabel()
        countLabel.text = "签到次数:"
        view.addSubview(countLabel)
        
        count.text = ""
        view.addSubview(count)
        
        //按钮
        button.setBackgroundImage(UIImage(named: "IconFlora"), forState: .Normal)
        button.sizeToFit()
        view.addSubview(button)
        button.snp_makeConstraints { (make) in
            //距顶50，水平居中
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(50)
            make.centerX.equalTo(view)
        }
        //
        qdLabel.snp_makeConstraints { (make) in
            //距顶部50，水平居中
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(100)
            make.center.equalTo(view).offset(CGPointMake(-20, 0))
        }
        
        qdSwitch.snp_makeConstraints { (make) in
            //位于qdLabel右边且中心对齐，间距20
            make.left.equalTo(qdLabel.snp_right).offset(20)
            make.centerY.equalTo(qdLabel)
        }
        
        countLabel.snp_makeConstraints { (make) in
            //位于qdSwitch底部间距100，水平居中
            make.top.equalTo(qdSwitch).offset(100)
            make.centerX.equalTo(view)
        }
        
        count.snp_makeConstraints { (make) in
            //位于countLabel底部，间距20，水平居中
            make.top.equalTo(countLabel).offset(20)
            make.centerX.equalTo(countLabel)
        }
    }
}
