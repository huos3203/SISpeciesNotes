//
//  AddNewEntryController.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-29.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import RealmSwift

/// 添加物种页面，编辑界面
class AddNewEntryController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - 属性
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var selectedCategory:CategoryModel!
    var species:SpeciesModel!
    
    var specieName:String?
    
    /// 当前所选中的标记信息
    var selectedAnnotation: SpeciesAnnotation!
    
    /// 重点：添加转场动画协议
    let presentTransitionDelegate = SDEModalTransitionDelegate()
    
    // MARK: - 控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
//        弹出到分类页面
        self.performSegueWithIdentifier("Categories", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "Coververtical")
        {
            //button按钮
            let tovc = segue.destinationViewController
            tovc.transitioningDelegate = presentTransitionDelegate
            tovc.modalPresentationStyle = .Custom
            super.prepareForSegue(segue, sender: sender)
        }
        else
        {
            //列别输入框点击事件
            let toVC = segue.destinationViewController as! CategoriesTableViewController
            toVC.transitioningDelegate = presentTransitionDelegate
            toVC.modalPresentationStyle = .Custom
//            super.prepareForSegue(segue, sender: sender)
        }
        
    }
    
    
    // MARK: - 按钮动作
    /**
    点击某个类别名称单元格，将内容返回并传递给一个试图控制器中
    
    - parameter segue: nil
    */
    @IBAction func unwindFromCategories(segue: UIStoryboardSegue) {
        let categoriesController = segue.sourceViewController as! CategoriesTableViewController
        selectedCategory = categoriesController.selectedCategories
        categoryTextField.text = selectedCategory.name
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        //
        if(identifier == "UnwindToMap")
        {
            validateFields()
            addNewSpecies()
        }
        
        return true
    }
    
    //MARK: - realm 持久化
    /**
        ```
         let realm = RLMRealm.defaultRealm()
         realm.beginWriteTransaction()
         realm.addObject(species)
         try! realm.commitWriteTransaction()
        ```
     */
    func addNewSpecies()
    {
        species = SpeciesModel()
        species.name = nameTextField.text!
        species.speciesDescription = descriptionTextView.text
        species.latitude = selectedAnnotation.coordinate.latitude
        species.longitude = selectedAnnotation.coordinate.longitude
        species.created = NSDate()
        species.category = selectedCategory
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(species)
        try! realm.commitWrite()
    }
    
    //MARK: - realm查询
    func fetchSpecieByName(specieName:String)
    {
        //        
    
    }
    
    
    // MARK: - 文本栏输入验证
    private func validateFields() -> Bool
    {
        if nameTextField.text!.isEmpty || descriptionTextView.text.isEmpty || selectedCategory == nil {
            let alertController = UIAlertController(title: "验证错误", message: "所有的文本栏都不能为空", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "确认", style: .Destructive, handler: {
                (alert: UIAlertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return false
        }else {
            return true
        }
    }
}
