//
//  CategoriesTableViewController.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-30.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import Realm
class CategoriesTableViewController: UITableViewController {

    // MARK: - 属性
    
    var categories = []
    
    //
    var results: RLMResults?
    var selectedCategories: CategoryModel!
    
    // MARK: - 控制器生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateDefaultCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(results!.count)
//        return Int(categories.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) 
        cell.textLabel?.text = (results![UInt(indexPath.row)] as! CategoryModel).name
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedCategories = self.results![UInt(indexPath.row)] as! CategoryModel
        return indexPath
    }
    
    //
    private func populateDefaultCategories() {
        self.results = CategoryModel.allObjects() // 1
        if results!.count == 0 { // 2
            let realm = RLMRealm.defaultRealm() // 3
            realm.beginWriteTransaction() // 4
            let defaultCategories = Categories.allValues // 5
            for category in defaultCategories {
                // 6
                let newCategory = CategoryModel()
                newCategory.name = category
                realm.addObject(newCategory)
            }
            try! realm.commitWriteTransaction() // 7
            self.results = CategoryModel.allObjects()
            //打印数据库的物理位置：
            print(RLMRealm.defaultRealm().path)
        }
    }
}
