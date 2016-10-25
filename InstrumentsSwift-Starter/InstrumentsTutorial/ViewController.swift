//
//  ViewController.swift
//  InstrumentsTutorial
//
//  Created by James Frost on 26/02/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

///首页面：搜索框，结果列表，

class ViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  fileprivate let flickr = Flickr()
  fileprivate var searches = [FlickrSearchResults]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? SearchResultsViewController {
      if let indexPath = (tableView.indexPathsForSelectedRows?.first)! as IndexPath? {
        destination.searchResults = searches[(indexPath as NSIndexPath).row]
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
        //deselectRow：取消cell被选择的状态
        tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
  }
}

// MARK: searchBarDelegate实现，
//当searchButton clicked时，启动Flickr搜索，将返回的信息插入到列表中
extension ViewController : UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    searchBar.isHidden = true
    activityIndicator.startAnimating()
    
    flickr.searchFlickrForTerm(searchBar.text!) { results, error in
      self.searchBar.isHidden = false
      self.activityIndicator.stopAnimating()

      if let error = error {
        let alert = UIAlertController(title: "Flickr Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
      }
      
      if let results = results {
        self.searches.append(results)
        self.tableView.insertRows(at: [ IndexPath(row: self.searches.count-1, section: 0) ], with: .top)
      }
    }
  }
}

//MARK: tableView相关方法
///设置1个单元，cell个数，cellForRowAt初始化cell，canEditRowAt可编辑设置，editingStyle指定cell侧滑删除的样式。
extension ViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1;
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searches.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
    
    let searchResult = searches[(indexPath as NSIndexPath).row]
    
    cell.textLabel?.text = searchResult.searchTerm
    cell.detailTextLabel?.text = "(\(searchResult.searchResults.count))"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      searches.remove(at: (indexPath as NSIndexPath).row)
      tableView.deleteRows(at: [ indexPath ], with: .fade)
    }
  }
}

