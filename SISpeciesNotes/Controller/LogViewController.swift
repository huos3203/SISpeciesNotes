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
    
    var realm:Realm!
//    var  notificationToken:NotificationToken?
    
    // MARK: 控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()  // 初始化搜索控制器
        definesPresentationContext = true
        
        
        realm = try! Realm()
        // Set realm notification block
//        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
//            self.tableView.reloadData()
//        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        self.tableView.reloadData()
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SearchBar Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        //过滤species
        filterSpecies(searchString!)
        let searchResultController = searchController.searchResultsController as! UITableViewController
        searchResultController.tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return Int(searchResults.count)
        }else {
            return Int(species!.count)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as! LogCell
        cell.titleLabel?.text = (species![indexPath.row]).name
        cell.subtitleLabel?.text = (species![indexPath.row].category?.name)
        cell.distanceLabel?.text = "\(species![indexPath.row].latitude)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //TODO: 删除动物记录
            delSpecieByName(species![indexPath.row] as SpeciesModel)
            //添加删除动画
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "Edit"  //前往编辑界面
        {
            
            let controller = segue.destination as! AddNewEntryController
            
            let indexPath = tableView.indexPathForSelectedRow
            // 获取分类对象
            let model:SpeciesModel? = species![indexPath!.row]
            controller.specieName = model!.name
            
            if let searchResultsController = searchController.searchResultsController as? UITableViewController, searchController.isActive {
                let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func scopeChanged(_ sender: AnyObject)
    {
        
    }
    
    // MARK: - Setter & Getter
    
    func initSearchController() {
        let searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.rowHeight = 63
        searchResultsController.tableView.register(LogCell.self, forCellReuseIdentifier: "LogCell")
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        
//        update
        fetchSpecies()
    }
    
    //MARK: 查询realm数据库已存在的物种
    func fetchSpecies()
    {
        self.species = try! Realm().objects(SpeciesModel)
    }
    
    //MARK: 筛选realm中已存在的物种
    func filterSpecies(_ searchText:String)
    {
        let predicate = NSPredicate(format: "name BEGINSWITH %@",  searchText)
        searchResults = try! Realm().objects(SpeciesModel).filter(predicate)
    }
   
    //侧滑删除动物信息
    func delSpecieByName(_ specie:SpeciesModel)
    {
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(specie)
        try! realm.commitWrite()
        
    }
    
   //MARK: 切换便签项改变排列顺序
    @IBAction func ibaSegmentdControlAction(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case 0:
                self.species = self.species!.sorted(byProperty: "name", ascending: true)
                self.tableView.reloadData()
            break
            case 1:
                self.species = self.species!.sorted(byProperty: "created", ascending: true)
                self.tableView.reloadData()
            break
        case 2:
            self.species = self.species!.sorted(byProperty: "longitude", ascending: true)
            self.tableView.reloadData()
            break
        default:
            print("失败")
        }
    }
    
}
