//
//  AddNewEntryController.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-29.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import MapKit
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
        
        if specieName != nil
        {
            fetchSpecieByName()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
//        弹出到分类页面
        self.performSegueWithIdentifier("Categories", sender: self)
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
        //保存数据，并返回上一页面
        if(identifier == "UnwindToMap")
        {
            validateFields()
            addNewSpecies()
        }
        
        return true
    }
    
//    转场动画切入点
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "Categories")
        {
            //列别输入框点击事件
            let toVC = segue.destinationViewController as! CategoriesTableViewController
            toVC.transitioningDelegate = presentTransitionDelegate
            toVC.modalPresentationStyle = .Custom
        }
        
    }
    
    
    
    //MARK: - realm 持久化
   
    func addNewSpecies()
    {
        species = SpeciesModel()
        guard  let name = nameTextField.text, let speciesDescription = descriptionTextView.text else
        {
            return
        }
        species.name = name
        species.speciesDescription = speciesDescription
        let latitude = selectedAnnotation.coordinate.latitude
        let longitude = selectedAnnotation.coordinate.longitude
        species.latitude = latitude
        species.longitude = longitude
        species.created = NSDate()
        species.category = selectedCategory
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(species)
        try! realm.commitWrite()
    }
    
    //MARK: - realm查询
    func fetchSpecieByName()
    {
        //跳转编辑页面,编辑动物信息时，先显示本地已经持久化的动物信息
        let predicate = NSPredicate(format: "SELF.name = %@",specieName!)
        let results1 = try! Realm().objects(SpeciesModel)
        let results = results1.filter(predicate)
        species  = results[0]
        nameTextField.text = species.name
        categoryTextField.text = species.category?.name
        descriptionTextView.text = species.description
        let lat = species.latitude
        let lon = species.longitude
//        selectedAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
        selectedAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(lon))
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
