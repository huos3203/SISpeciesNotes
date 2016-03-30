//
//  LogViewController.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-29.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

/// 记录界面

class LogViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    /// 物种
    var species:Results<SpeciesModel>?
    /// 搜索结果
    var searchResults:Results<SpeciesModel>!
    
    var searchController: UISearchController!
    
    // MARK: 控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()  // 初始化搜索控制器
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SearchBar Delegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        //过滤species
//        searchResults = species.
        filterSpecies(searchString!)
        
        let searchResultController = searchController.searchResultsController as! UITableViewController
        searchResultController.tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return Int(searchResults.count)
        }else {
            return Int(species!.count)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as! LogCell
        cell.textLabel?.text = (species![indexPath.row]).name
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            //TODO: 删除动物记录
            
        }
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit" {
            let controller = segue.destinationViewController as! AddNewEntryController
            
            let indexPath = tableView.indexPathForSelectedRow
//            获取分类对象
            let model:SpeciesModel? = species![indexPath!.row]
            controller.specieName = model!.name
            
            if let searchResultsController = searchController.searchResultsController as? UITableViewController where searchController.active {
                let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func scopeChanged(sender: AnyObject) {
        
    }
    
    // MARK: - Setter & Getter
    
    func initSearchController() {
        let searchResultsController = UITableViewController(style: .Plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.rowHeight = 63
        searchResultsController.tableView.registerClass(LogCell.self, forCellReuseIdentifier: "LogCell")
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        fetchSpecies()
    }
    
    //MARK: 查询realm数据库已存在的物种
    func fetchSpecies()
    {
        self.species = try! Realm().objects(SpeciesModel)
    }
    
    //MARK: 筛选realm中已存在的物种
    func filterSpecies(searchText:String)
    {
//        let realm = RLMRealm.defaultRealm()
//        realm.beginWriteTransaction()
//        realm.objcts(SpeciesModel)
        let predicate = NSPredicate(format: "name BEGINSWITH %@",  searchText)
        searchResults = try! Realm().objects(SpeciesModel).filter(predicate)
    }
    
}
