//
//  ActivationController.swift
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/7/12.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Cocoa

class ActivationController: NSViewController {
    
    @IBOutlet weak var qqField: NSTextField!
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var phoneField: NSTextField!
    @IBOutlet weak var self1Field: NSTextField!
    @IBOutlet weak var self2Field: NSTextField!
    
    @IBOutlet weak var self1label: NSTextField!
    @IBOutlet weak var self2label: NSTextField!
    
    @IBOutlet weak var qqAsterisk: NSTextField!
    @IBOutlet weak var emailAsterisk: NSTextField!
    @IBOutlet weak var phoneAsterisk: NSTextField!
    
    //contraint
    //phone
    @IBOutlet weak var ibPhoneToViewVertical:NSLayoutConstraint!
    
    
    //email
    @IBOutlet weak var ibEmailToQQVertical:NSLayoutConstraint!
    
    @IBOutlet weak var ibEmailToViewVertical:NSLayoutConstraint!
    
    //self1
    @IBOutlet weak var ibSelf1ToPhoneVertical:NSLayoutConstraint!
    
    @IBOutlet weak var ibSelf1ToQQVertical:NSLayoutConstraint!
    
    @IBOutlet weak var ibSelf1ToViewVertical:NSLayoutConstraint!
    
    
    //self2
    @IBOutlet weak var ibSelf2ToEmailVertical:NSLayoutConstraint!
    
    @IBOutlet weak var ibSelf2ToPhoneVertical:NSLayoutConstraint!
    
    @IBOutlet weak var ibSelf2ToQQVertical:NSLayoutConstraint!
    
    @IBOutlet weak var ibSelf2ToViewVertical:NSLayoutConstraint!
    
    var field1name:String!
    var field2name:String!
    
    var field1needprotect:Bool,field2needprotect:Bool
    var selffieldnum:Int    // 用户选择自定义列数量
    var bindNum:Int // 用户选择系统定义数量。
    var definechecked:Int
    
    var needReApply:Int
    var applyId:Int

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func initWithWidgetLayout() {
        //
        var isShowQQ = false
        var isSHowPhone = false
        var isSHowEmail = false
        var isShowSelf1 = false
        var isShowSelf2 = false
        
        if (definechecked != 0 || selffieldnum != 0) {
            // 用户手动选择列
            // 系统定义选项,ＱＱ，phone，email
            if (definechecked&1 != 0) {
                isShowQQ = true
            }
            if (definechecked&2 != 0) {
                isSHowPhone = true
            }
            if (definechecked&4 != 0) {
                isSHowEmail = true
            }
            // 用户自定义选项
            if (selffieldnum == 1) {
                isShowSelf1 = true
            } else if (selffieldnum == 2) {
                isShowSelf1 = true
                isShowSelf2 = true
            }
        }else{
            isShowQQ = true
            isSHowPhone = true
            isSHowEmail = true
        }
        
        var num = 1
        var y = 0
        //    NSInteger priority=0;
        
        
        //显示QQ
        if (isShowQQ) {
            //默认以相邻控件的约束为主
            num = num + 1
            
        }else{
            y = y + 1
            qqAsterisk.hidden = true
            qqField.hidden = true
        }
        
        //显示phone
        if (isSHowPhone) {
            //隐藏qq
            if (isShowQQ) {
                //默认以相邻控件的约束为主
            }else{
                ibPhoneToViewVertical.priority = 722.0;
            }
            //        priority = 2-num-y;
            
            //        switch (priority) {
            //            case <#constant#>:
            //                <#statements#>
            //                break;
            //
            //            default:
            //                break;
            //        }
            
            
        }else{
            phoneAsterisk.hidden = true
            phoneField.hidden = true
        }
        
        //显示email
        if (isSHowEmail) {
            
            if (isSHowPhone) {
                //默认以相邻的控件之间的约束为主
                
            }else if(isShowQQ){
                //QQ显示时，提高约束优先级
                ibEmailToQQVertical.priority = 722.0
            }else{
                //隐藏qq,phone
                ibEmailToViewVertical.priority = 722.0
            }
            
        }else{
            emailAsterisk.hidden = true
            emailField.hidden = true
        }
        
        
        //field1name  field2name
        //field1needprotect  field2needprotect
        
        ////判断自定义字段的个数,是否用原有规则
        if (isShowSelf1) {
            self1label.stringValue = "\(field1name):"
            if (isSHowEmail) {
                //默认以相邻的控件之间的约束为主
            }else if (isSHowPhone){
                //当isShowPhone真时,提升Phone控件之间的约束优先级
                ibSelf1ToPhoneVertical.priority = 722.0;
            }else if(isShowQQ){
                //当isShowQQ真时,提升QQ控件之间的约束优先级
                ibSelf1ToQQVertical.priority = 722.0;
            }else{
                //隐藏该控件以上的控件
                ibSelf1ToViewVertical.priority = 722.0;
            }
            
            if (field1needprotect) {
//                self1Field.secureTextEntry = true
            }
            
        }else{
            self1label.hidden = true
            self1Field.hidden = true
        }
        
        if (isShowSelf2) {
            
            self2label.stringValue = "\(field2name):"
            if (isShowSelf1) {
                //默认以相邻的控件之间的约束为主
            }else if(isSHowEmail){
                //当isShowQQ真时,提升QQ控件之间的约束优先级
                ibSelf2ToEmailVertical.priority = 722.0;
            }else if(isSHowPhone){
                //当isShowPhone真时,提升Phone控件之间的约束优先级
                ibSelf2ToPhoneVertical.priority = 722.0;
            }else if(isShowQQ){
                //当isShowQQ真时,提升QQ控件之间的约束优先级
                ibSelf2ToQQVertical.priority = 722.0;
            }else{
                ibSelf2ToViewVertical.priority = 722.0;
            }
            
            if (field2needprotect) {
//                self2Field.secureTextEntry = YES;
            }
        } else {
            self2label.hidden = true
            self2Field.hidden = true
        }

        
    }
   
}
