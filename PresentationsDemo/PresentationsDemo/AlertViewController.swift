//
//  AlertViewController.swift
//  PresentationsDemo
//
//  Created by Joyce Echessa on 4/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //注意：在iPad下ActionSheet将以popover的形式展现出来，而且当Action的Style为cancel的时候，Action按钮是不会被显示在iPad上的。
    //ActionSheet的显示效果:需要如下修正：
    //    alertController.popoverPresentationController?.sourceView = view
    //    alertController.popoverPresentationController?.sourceRect = sender.frame
    //原因：在iPad上，ActionSheet会被以popover的形式显示出来，它衣服在当前页面的某一个组件上，因为必须指定一个sourceView用于指定ActionSheet的依附点（在这个空间的周围被弹出），同时还应指定一个sourceRect用于指定他被包含在哪一片区域内
    
    @IBAction func showAlertWasTapped(_ sender: UIButton)
    {
        let alertController = UIAlertController(title: "一点都简单", message: "来自一点都简单的Alert", preferredStyle: .alert)
        let delAction = UIAlertAction.init(title: "删除", style: .cancel, handler:{del in
            print("4444:\(del.title!)")
        })
        alertController.addAction(delAction)
        let okAction = UIAlertAction.init(title: "确定", style: .destructive, handler:
            {ok in
                print("OK : \(ok.title!)")
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: {print("显示成功")})
    }
}
