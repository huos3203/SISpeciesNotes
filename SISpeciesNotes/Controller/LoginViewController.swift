//
//  LoginViewController.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/15.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    //存储属性： 用户名，密码
    @IBOutlet weak var ibUserNameField:UITextField!
    @IBOutlet weak var ibPasswordField:UITextField!
    //button不能weak,会导致实例化失败
    @IBOutlet var ibLoginClientButton: UIButton!
    
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        autoLayoutBySnapkit()
    }
    
    func autoLayoutBySnapkit()
    {
        //添加到根View上
        //从此以后基本可以抛弃CGRectMake了
        ibUserNameField = UITextField()
        ibUserNameField.backgroundColor = UIColor.redColor()
        
        //初始化密码控件
        ibPasswordField = UITextField()
        ibPasswordField.text = "123456"
        ibPasswordField.secureTextEntry = true
        ibPasswordField.backgroundColor = UIColor.redColor()
        
        //登录按钮
        ibLoginClientButton = UIButton(type:.Custom)
        ibLoginClientButton.contentEdgeInsets=UIEdgeInsetsMake(10, 20, 10, 20)
        ibLoginClientButton.backgroundColor = UIColor.redColor()
        ibLoginClientButton.setTitle("Login=======", forState:.Normal)
        ibLoginClientButton.sizeToFit()
        
        //在做autoLayout之前 一定要先将view添加到superview上 否则会报错
        view.addSubview(ibUserNameField)
        view.addSubview(ibPasswordField)
        view.addSubview(ibLoginClientButton)
        
//        [初级] 让两个高度为150的view垂直居中且等宽且等间隔排列 间隔为10(自动计算其宽度)
        
//        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        ibUserNameField.snp_makeConstraints { (make) in
            //水平居中，居LayoutGuideTop顶部50，边距40
            make.centerX.equalTo(view)
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(50).priorityHigh()
            make.left.equalTo(view).offset(40);make.right.equalTo(view).offset(-40)
            //等价上一句：
//            make.left.right.equalTo(view).inset(UIEdgeInsetsMake(0, 40, 0, 40))
        }
        
        
        //给PassWordField控件添加指定约束条件
        ibPasswordField.snp_makeConstraints { (make) in
            //相对于父视图水平居中
            make.centerX.equalTo(ibUserNameField)
            make.left.right.equalTo(ibUserNameField)
            //顶部距ibUserNameField对齐
            make.top.equalTo(ibUserNameField.snp_bottom).offset(40)
        }
        
        //设置Button约束
        ibLoginClientButton.snp_makeConstraints { (make) in
            //顶部相距password底部50 ，水平居中，自适应大小
            make.top.equalTo(ibPasswordField.snp_bottom).offset(50)
            make.centerX.equalTo(view)
//            make.size.equalTo(ibPasswordField).priorityLow()
            
        }
       
        
//        view.setNeedsUpdateConstraints()
    }
    
    
    //创建segue 
    func createCustomSegue()
    {
        let storyBoardSegue = UIStoryboardSegue(identifier: "LoginSuccessIdentifier", source: self, destination: AddNewEntryController()) {
            //跳转后，执行如下代码
            
        }
//        ibLoginClientButton.
    
    }
    
    //登录事件:通过LoginClient结构体方法
    @IBAction func login(sender:AnyObject)
    {
        guard let username = self.ibUserNameField.text,passWord = self.ibPasswordField.text else
        {
            return
        }
        LoginClient.loginClient(username, passWord: passWord) { (isSuccess, loginError) in
            //
            switch loginError!
            {
            case .EmptyUserName,.EmptyPassword:
                //用户名为空
                break
            case .UserNotFound:
                break
            case .WrongPassword:
                break
            }
        }
    
    }
    
}
