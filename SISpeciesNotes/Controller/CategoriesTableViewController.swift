//
//  CategoriesTableViewController.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-30.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import RealmSwift

/// 物种总览提示页面
class CategoriesTableViewController: UITableViewController {

    // MARK: - 属性
    
    var categories = []
    
    //
    
    var selectedCategories: CategoryModel?
    var realm: Realm!
    var results : Results<CategoryModel>?
//    var results = [Results<CategoryModel>]()
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
        cell.textLabel?.text = results![indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedCategories = self.results![indexPath.row]
        return indexPath
    }
    

    private func populateDefaultCategories() {
        realm = try! Realm()
        self.results =  realm.objects(CategoryModel)
        if results!.count == 0 { // 2
            realm.beginWrite() // 4
            let defaultCategories = Categories.allValues // 5
            for category in defaultCategories {
                // 6
                let newCategory = CategoryModel()
                newCategory.name = category
                realm.add(newCategory)
            }
            try! realm.commitWrite() // 7
            self.results = realm.objects(CategoryModel)
            //打印数据库的物理位置：
            print(realm.path)
        }
    }
}
