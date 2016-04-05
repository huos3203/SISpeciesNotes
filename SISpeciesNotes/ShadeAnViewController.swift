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


extension UILabel
{
    func fireTimer()
    {
        let timer = NSTimer(timeInterval: 4.0, target: self, selector: #selector(UILabel.shadeAnimation), userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
    }
    func shadeAnimation()
    {
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(UILabel.hidden as (UILabel) -> () -> ()), userInfo: nil, repeats: false)
    }
    func hidden()
    {
        //隐藏
        UIView.animateWithDuration(1.0, animations: {
            //20s一隐藏，滞后4s隐藏
            self.hidden = true
            }) { (completion) -> Void in
                //隐藏之后，暂停20秒再显示出来
                if completion
                {
                    //4s之后，显示
                    NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(UILabel.show), userInfo: nil, repeats: false)
                }
        }
    }
    
    func show()
    {
        let mvFrame = UIScreen.mainScreen().bounds.size
        //随机坐标
        var x_random = arc4random() % UInt32(mvFrame.width - 50)
        var y_random = arc4random() % UInt32(mvFrame.height - 50)
        //动画
        UIView.animateWithDuration(1.0, animations: {
            //20s一隐藏，滞后4s隐藏
            self.hidden = false
            self.frame.origin = CGPointMake(CGFloat(x_random), CGFloat(y_random))
            },completion:nil)
    }
}

class ShadeAnViewController: UIViewController {

    @IBOutlet weak var ibShadeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibShadeLabel.fireTimer()
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
