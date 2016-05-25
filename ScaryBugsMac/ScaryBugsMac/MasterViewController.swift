//
//  MasterViewController.swift
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/5/23.
//  Copyright © 2016年 recomend. All rights reserved.
//

import AppKit
import EDStarRating

class MasterViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,EDStarRatingProtocol {

    var bugs:Array<ScaryBugDoc>!

    
    @IBOutlet weak var bugsTableView: NSTableView!
    
    @IBOutlet weak var bugTitleView: NSTextField!
    
    @IBOutlet weak var bugImageView: NSImageView!
    
    @IBOutlet weak var bugRating: EDStarRating!
    
    
    override func viewDidLoad() {
        
        //获取数据
        bugs = ScaryBugDoc.getSampleData()
        
        
    }
    
    override func loadView() {
        //
        super.loadView()
        
        self.bugRating.starImage = NSImage.init(named: "star")
        self.bugRating.starHighlightedImage = NSImage.init(named: "shockedface2_full")
        self.bugRating.starImage = NSImage.init(named: "shockedface2_empty")
        self.bugRating.maxRating = 5
        self.bugRating.delegate = self as EDStarRatingProtocol
        self.bugRating.horizontalMargin = 12
        self.bugRating.editable = true
        self.bugRating.displayMode = UInt(EDStarRatingDisplayFull)

        self.bugRating.rating = 0.0
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
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        //
        let bugDoc = selectedBugDoc()
        setDetailInfo(bugDoc)
    }
    
    func selectedBugDoc() -> ScaryBugDoc? {
        //
        let selectedRow = bugsTableView.selectedRow
        if(selectedRow >= 0 && bugs.count > selectedRow){
        
            return bugs[selectedRow]
        }
        return nil
    }
    
    func setDetailInfo(bugDoc:ScaryBugDoc!) {
        //
        var title = ""
        var image:NSImage = NSImage.init()
        var rating:Float = 0
        if(bugDoc != nil){
            //
            title = bugDoc.data.title
            image = bugDoc.fullImage
            rating = bugDoc.data.rating
        }
        bugTitleView.stringValue = title
        bugImageView.image = image
        bugRating.rating = rating
    }
    
    @IBAction func bugTitleDidEndEdit(sender: AnyObject) {
        
        // 1. Get selected bug
        if let selectedBug = selectedBugDoc(){
            
            // 2. Get the new name from the text field
            selectedBug.data.title = bugTitleView.stringValue
            
            // 3. Update the cell
            let indexSet = NSIndexSet.init(index: 2)
            let columnIndexSet = NSIndexSet.init(index: 0)
            bugsTableView.reloadDataForRowIndexes(indexSet, columnIndexes: columnIndexSet)
        }
    }
    
    @IBAction func addBug(sender: AnyObject) {
        //
        // 1. Create a new ScaryBugDoc object with a default name
        let bugDoc = ScaryBugDoc.init(title: "", rating: 2, thumbImage: NSImage.init(named: "centipedeThumb")!, fullImage: NSImage.init(named: "centipede")!)
        
        // 2. Add the new bug object to our model (insert into the array)
        bugs.append(bugDoc)
        let newRowIndex = bugs.count - 1
        // 3. Insert new row in the table view
        bugsTableView.insertRowsAtIndexes(NSIndexSet.init(index: newRowIndex), withAnimation: .SlideRight)
        
        // 4. Select the new bug and scroll to make sure it's visible
        bugsTableView.selectRowIndexes(NSIndexSet.init(index: newRowIndex), byExtendingSelection: false)
        bugsTableView.scrollRowToVisible(newRowIndex)
    }
    
    @IBAction func deleteBug(sender: AnyObject) {
        
        // 1. Get selected doc
        let selectedBug = selectedBugDoc()
        
        // 2. Remove the bug from the model
        if(selectedBug != nil){
            
            // let index = try! bugs.index
            bugs.removeObject(selectedBug!)
        }
        
        // 3. Remove the selected row from the table view.
        bugsTableView.removeRowsAtIndexes(NSIndexSet.init(index: bugsTableView.selectedRow), withAnimation: .SlideRight)
        
        // Clear detail info
        setDetailInfo(nil)
        
    }
    
}


