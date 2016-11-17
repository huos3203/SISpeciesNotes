//
//  PopoverViewController.swift
//  PresentationsDemo
//
//  Created by Joyce Echessa on 4/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionWasTapped(_ sender: UIBarButtonItem)
    {
        let storyboard:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopoverViewController")
        vc.modalPresentationStyle = .popover
        if vc.modalPresentationStyle == .popover {
            let popover:UIPopoverPresentationController = vc.popoverPresentationController!
            //barButtonItem决定这个popover页面依附在哪一个按钮下
            popover.barButtonItem = sender
            popover.delegate = self
        }

        present(vc, animated: true, completion: {
            print("popoverViewController completion")
        })
    }
}

//在iPhone下你没有办法去关闭当前这个弹出来的窗口，为了实现这个功能，我们可以设置一个navigation controller到这个页面。
extension PopoverViewController:UIPopoverPresentationControllerDelegate
{
    //在你 compact-with 的情况下被调用，也就是在这个例子里这个方法只会在iPhone应用里执行这个方法。运行app将得到如下效果。
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
        //如果你想让iPhone也能够以popver的形式显示这个页面
//        return .none
    }
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        //在present页面添加导航控制器
        let navigationController = UINavigationController.init(rootViewController: controller.presentedViewController)
        //设置了一个navagationbar并在他的右边添加了一个Done按钮，这个按钮绑定了一个dissmiss方法用来关闭整个窗口。
        let barDone = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(PopoverViewController.dismiss as (PopoverViewController) -> () -> ()))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = barDone
        return navigationController
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
