//
//  ActivationSuccessController.swift
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/7/12.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Cocoa

class ActivationSuccessController: NSViewController {

    
    
    @IBOutlet weak var ibShowInfoLabel: NSTextField!
    
    @IBOutlet weak var qqLabel: NSTextField!
    @IBOutlet weak var phoneLabel: NSTextField!
    @IBOutlet weak var emailLabel: NSTextField!
    
    @IBOutlet weak var ibRemarkLabel: NSTextField!
    @IBOutlet weak var ibMakerLabel: NSTextField!
    @IBOutlet weak var ibSelfTitleLabel: NSTextField!
    
    @IBOutlet weak var ibRetoActivation: NSButton!
    
    var fileId = 0
    var orderId = 0
    
    var qq:String!
    var phone:String!
    var email:String!
    var field1name:String!
    var field2name:String!
    
    var bOpenInCome = 0
    
    var showInfo:String!
    var needShowDiff = 0
    var makerNick:String!
    var needReapply = 0
    var applyId = 0
    var remark:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        qqLabel.stringValue =  qq
        phoneLabel.stringValue = phone
        emailLabel.stringValue = email
        //    BOOL uu = [qq isEqualToString:""]
        
        if (ToolString.isBlankString(qq)) {
            qqLabel.stringValue =  "无"
            qq = "无"
        }
        if (ToolString.isBlankString(phone)) {
            phoneLabel.stringValue = "无"
            phone = "无"
        }
        if (ToolString.isBlankString(email)) {
            emailLabel.stringValue = "无"
            email = "无"
        }
        if (ToolString.isBlankString(remark)) {
            remark = ""
        }
        
        if (needReapply == 1) {
            ibSelfTitleLabel.stringValue = "激活失败"
            
        }else{
            ibSelfTitleLabel.stringValue = "申请已提交"
            ibRetoActivation.hidden = true
        }
        
        
        if (needShowDiff == 0) {
            ibShowInfoLabel.textColor = kGreen
        }else{
            ibShowInfoLabel.textColor = NSColor.orangeColor()
        }
        
        ibShowInfoLabel.stringValue = showInfo
        
        //作者
        ibMakerLabel.stringValue = makerNick
        ibRemarkLabel.stringValue = remark
    }
    
    @IBAction func ibaRetoActivation(sender: AnyObject) {
        
        AppDelegateHelper.sharedAppDelegateHelper().getApplyFileInfoByApplyId(applyId)
    }
    
    override func dismissController(sender: AnyObject?) {
        self.view.window?.performClose(self);
    }
}
