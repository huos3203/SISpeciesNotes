//
//  LoginViewController.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/15.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //存储属性： 用户名，密码
    @IBOutlet weak var ibUserNameField:UITextField!
    @IBOutlet weak var ibPasswordField:UITextField!
    
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
