//
//  PercentageCalculatorViewController.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/11.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

class PercentageCalculatorViewController: UIViewController {

    
    @IBOutlet weak var ibNumberSlider: UISlider!
    @IBOutlet weak var ibNumberLabel: UILabel!
    
    @IBOutlet weak var ibPercentageSlider: UISlider!
    @IBOutlet weak var ibPercentageLabel: UILabel!
    
    @IBOutlet weak var ibResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    拖动事件
    
    @IBAction func ibaNumberSliderChangeValueAction(_ sender: UISlider) {
        
//        更新numberLabel 和 ResultLabel
//        resultLabel = number * percentage * 0.01
        let result = updateResult((Int(sender.value),Int(self.ibPercentageSlider.value)))
        self.ibNumberLabel.text = "\(result.0)"
        self.ibResultLabel.text = "\(result.1)"
        
        
        var sender = Int(sender.value)
        let result2 = updateResult(&sender, num: Int(self.ibPercentageSlider.value))
        self.ibNumberLabel.text = "\(sender)"
        self.ibResultLabel.text = "\(result2)"
        
    }
    
    @IBAction func ibaPercentageSliderAction(_ sender: UISlider) {
        
//        更新 percentageLabel 和 resultLabel
        
//        resultLabel = number * percentage * 0.01
        let result = updateResult((Int(sender.value),Int(self.ibNumberSlider.value)))
        
        self.ibPercentageLabel.text = "\(result.0)"
        
        self.ibResultLabel.text = "\(result.1)"
    }
    
//    通过inout形参
    func updateResult(_ sender:inout Int,num:Int)->Int
    {
        let result = sender * num / 100
        sender += 1
        return result
    }
    
    
    
    func updateResult(_ num:(Int,Int)) -> (Int,Int)
    {
        let result = num.0 * num.1 / 100
        return (num.0,Int(result))
    }
    
    
//    问题代码
    func updateLabels(_ nV: Float?, _ pV: Float?, _ rV: Float) {
        if let v = nV {
            self.ibNumberLabel.text = "\(v)"
        }
        if let v = pV {
            self.ibPercentageLabel.text = "\(v)%"
        }
        
        self.ibResultLabel.text = "\(rV + 10)"
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
