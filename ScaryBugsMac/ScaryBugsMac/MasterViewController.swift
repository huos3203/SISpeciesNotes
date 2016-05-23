//
//  MasterViewController.swift
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/5/23.
//  Copyright © 2016年 recomend. All rights reserved.
//

import AppKit

class MasterViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {

    var bugs:Array<ScaryBugDoc>!
    
    override func viewDidLoad() {
        
        //获取数据
        bugs = ScaryBugDoc.getSampleData()
        
        
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return bugs.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Get a new ViewCell
        let cellView = tableView.makeViewWithIdentifier((tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        // Since this is a single-column table view, this would not be necessary.
        // But it's a good practice to do it in order by remember it when a table is multicolumn.
        if tableColumn?.identifier == "BugColumn" {
            //
            let bugDoc = self.bugs[row]
            cellView.imageView?.image = bugDoc.thumbImage
            cellView.textField?.stringValue = bugDoc.data.title
            return cellView
        }
        
        return cellView
    }
}
