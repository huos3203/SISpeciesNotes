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
    @IBOutlet var ibUserNameField:UITextField!
    @IBOutlet var ibPasswordField:UITextField!
    //button不能weak,会导致实例化失败
    @IBOutlet var ibLoginClientButton: UIButton!
    
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        autoLayoutBySnapkit()
        createCustomSegue()
    }
    
    func autoLayoutBySnapkit()
    {
        //添加到根View上
        //从此以后基本可以抛弃CGRectMake了
        ibUserNameField = UITextField()
        ibUserNameField.backgroundColor = UIColor.red
        
        //初始化密码控件
        ibPasswordField = UITextField()
        ibPasswordField.text = "123456"
        ibPasswordField.isSecureTextEntry = true
        ibPasswordField.backgroundColor = UIColor.red
        
        //登录按钮
        ibLoginClientButton = UIButton(type:.custom)
        ibLoginClientButton.contentEdgeInsets=UIEdgeInsetsMake(10, 20, 10, 20)
        ibLoginClientButton.backgroundColor = UIColor.red
        ibLoginClientButton.setTitle("Login=======", for:UIControlState())
        ibLoginClientButton.sizeToFit()
        ibLoginClientButton.addTarget(self, action: #selector(LoginViewController.login(_:)), for:.touchDown)
        
        //在做autoLayout之前 一定要先将view添加到superview上 否则会报错
        view.addSubview(ibUserNameField)
        view.addSubview(ibPasswordField)
        view.addSubview(ibLoginClientButton)
        view.backgroundColor = UIColor.black
        
//        [初级] 让两个高度为150的view垂直居中且等宽且等间隔排列 间隔为10(自动计算其宽度)
        
//        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        ibUserNameField.snp_makeConstraints { (make) in
            //水平居中，居LayoutGuideTop顶部50，边距40
            make.centerX.equalTo(view)
            make.height.equalTo(40)
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(50).priorityHigh()
            make.left.equalTo(view).offset(40);make.right.equalTo(view).offset(-40)
            //等价上一句：
//            make.left.right.equalTo(view).inset(UIEdgeInsetsMake(0, 40, 0, 40))
        }
        
        
        //给PassWordField控件添加指定约束条件
        ibPasswordField.snp_makeConstraints { (make) in
            //相对于父视图水平居中
            make.centerX.equalTo(ibUserNameField)
            make.left.right.equalTo(ibUserNameField)
            make.height.equalTo(ibUserNameField)
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

    
    //登录事件:通过LoginClient结构体方法
    @IBAction func login(_ sender:AnyObject)
    {
        guard let username = self.ibUserNameField.text,let passWord = self.ibPasswordField.text else
        {
            return
        }
        
        let indcator = UIActivityIndicatorView(activityIndicatorStyle:.gray)
        indcator.startAnimatingInSuperView(view)
        print("开始....")
        
        var alterview:UIAlertController!
        var message:String!
        LoginClient.loginClient(username, passWord: passWord) { (isSuccess, loginError) in
            //
            indcator.stopAnimating()
            
            if (loginError == nil)
            {
                self.present(OnclickLikeViewController(), animated: true, completion: nil)
                return
            }
            
            switch loginError!
            {
            case .emptyUserName,.emptyPassword:
                //提示框提示用户名、用户密码为空
                message = "用户名、用户密码为空."
            case .userNotFound:
                // 用户名错误
                message = "用户名错误"
            case .wrongPassword:
                message = "用户密码错误"
            }
            
            //配置提示内容
            alterview = UIAlertController(title: "错误提示", message:message,preferredStyle: .alert)
            //configuring User Actions
            let cancelAction = UIAlertAction(title: "确定",style: .cancel){_ in
                //执行相关方法
                print("打印错误信息")
            }
            
            alterview.addAction(cancelAction)
            self.present(alterview, animated: true, completion: nil)
        }
    }
    
    
    //创建segue,可以通过扩展segue类来自定义segue操作，不适合在代码中手动创建
    func createCustomSegue()
    {
        
        //        let storyBoardSegue = UIStoryboardSegue(identifier: "LoginSuccessIdentifier", source: self, destination: AddNewEntryController()) {
        //            //跳转后，执行如下代码
        //
        //        }
        //
        //        
        
    }
    
}

extension UIActivityIndicatorView
{
    
    func startAnimatingInSuperView(_ superview:UIView)
    {
        superview.addSubview(self)
        //居中在父视图正中心
        self.snp_makeConstraints { (make) in
            make.center.equalTo(superview)
        }
        hidesWhenStopped = true
        startAnimating()
    }
    
    
    
}
