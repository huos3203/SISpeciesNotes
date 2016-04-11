//
//  ShadeAnViewController.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/5.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit


//协议，隐藏和显示方法
protocol shadeAnimation
{
    func hidden()
    func show()
}




class ShadeAnViewController: UIViewController {

    @IBOutlet weak var ibShadeLabel: UILabel!
//    var invalidTimer:()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = ibShadeLabel.fireTimer()
        let shadevc = ShadeAnimationViewController()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
