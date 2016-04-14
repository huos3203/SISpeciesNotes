//
//  LoginClient.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/15.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import Foundation



struct LoginClient
{
    
   let userInfo = ["hsg":"123456"]
//    错误类型
    enum LOGINError:ErrorType {
        case EmptyUserName,EmptyPassword,UserNotFound,WrongPassword
    }
    
    static func loginClient(userName:String,passWord:String,completionHandler:(Bool,LOGINError?)->())
    {
        //模拟延迟访问登录
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            //延迟后，开始执行
            if userName.isEmpty{
                completionHandler(false,.EmptyUserName)
                return
            }
            
            if passWord.isEmpty
            {
                completionHandler(false,.EmptyPassword)
                return
            }
            
            if !userInfo.keys.contains(userName)
            {
                completionHandler(false,.UserNotFound)
                return
            }
            
            if userInfo["hsg"] != passWord
            {
                completionHandler(false,.WrongPassword)
                return
            }
            
            completionHandler(true,nil)
        }
    }
    
    
}