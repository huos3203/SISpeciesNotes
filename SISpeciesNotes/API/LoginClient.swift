//
//  LoginClient.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/15.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import Foundation


//let userInfo = ["how":"123456"]

struct LoginClient
{
   //class/static修饰的成员(类成员)不能访问没有class/static修饰的成员(实例成员)
   static let userInfo = ["how":"123"]
//    错误类型
    enum LOGINError:Error {
        case emptyUserName,emptyPassword,userNotFound,wrongPassword
    }
    
    static func loginClient(_ userName:String,passWord:String,completionHandler:@escaping (Bool,LOGINError?)->())
    {
        print("用户名:\(userName) 密码:\(passWord)")
        //模拟延迟访问登录
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            //延迟后，开始执行
            if userName.isEmpty{
                completionHandler(false,.emptyUserName)
                return
            }
            
            if passWord.isEmpty
            {
                completionHandler(false,.emptyPassword)
                return
            }
            
            if !userInfo.keys.contains(userName)
            {
                completionHandler(false,.userNotFound)
                return
            }
            
            if userInfo["how"] != passWord
            {
                completionHandler(false,.wrongPassword)
                return
            }
            
            completionHandler(true,nil)
        }
    }
}
