//
//  MasterViewController.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/26.
//  Copyright © 2016年 recomend. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    // Add new private variables to interface
    var selDocument:PTKDocument! = nil
    var localRoot:NSURL!{
        get{
            if let _ = self.localRoot {
                //
                return self.localRoot
            }
            
            let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            self.localRoot = paths[0]
            return self.localRoot
        }
        set{}
    }
    
    
    //MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //app should correctly pick up the list of documents since last time it was run
        refresh()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        
        // Determine a unique filename to create
        let fileURL = getDocURL(getDocFilename("Photo", uniqueInObjects: true)!)
        
        // Create new document and save to the filename
        let doc = PTKDocument.init(fileURL: fileURL!)
        doc.saveToURL(fileURL!, forSaveOperation: .ForCreating) { (success) in
            //
            if(!success){
                return
            }
            
            NSLog("File created at \(fileURL)")
            let metadata = doc.metadata
            let fileURL = doc.fileURL
            let state = doc.documentState
            let version = NSFileVersion.currentVersionOfItemAtURL(fileURL)
            //
            self.selDocument = doc
            dispatch_async(dispatch_get_main_queue(), { 
                self.addOrUpdateEntryWithURL(fileURL, metadata: metadata!, state: state, version: version!)
                self.performSegueWithIdentifier("showDetail", sender: self)
            })
        }
        
    }

    // MARK: - Segues
    // Replace prepareForSegue with the following
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    // Replace tableView:cellForRowAtIndexPath with the following
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let entry = objects[indexPath.row] as! PTKEntry
        cell.imageView?.image = entry.metadata.thumbnail
        cell.textLabel!.text = entry.description
        cell.detailTextLabel?.text = entry.version.modificationDate?.mediumString()
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

//MARK Helpers
extension MasterViewController{
    
    func iCloudOn()->Bool {
        return false
    }
    
    func getDocURL(fileName:String) -> NSURL? {
        //
        if iCloudOn() {
            //TODO
            return nil
        }else{
            return self.localRoot.URLByAppendingPathComponent(fileName)
        }
    }
    
    func docNameExistsInObjects(docName:String) -> Bool {
        //
        var nameExists = false
        for entry:PTKEntry in (objects as? [PTKEntry])! {
            //
            if entry.fileURL.lastPathComponent == docName {
                //
                nameExists = true
                break
            }
        }
        return nameExists
    }
    
    
    func getDocFilename(prefix:String,uniqueInObjects:Bool)->String? {
        //
        var docCount = 0
        var newDocName = ""
        // At this point, the document list should be up-to-date.
        let done = false
        var first = true
        while (!done) {
            //
            if first {
                //
                first = false
                newDocName = "\(prefix).\(PTK_EXTENSION)"
            }
            // Look for an existing document with the same name. If one is
            // found, increment the docCount value and try again.
            var nameExists = false
            if uniqueInObjects {
                nameExists = docNameExistsInObjects(newDocName)
            }else{
                return nil
            }
            
            if !nameExists {
                //
                break
            }else{
                docCount += 1
            }
        }
        return newDocName
    }

}

//creating a document 

//1. Alloc/init the PTKDocument with the URL to save the file to.
//2. Call saveToURL to initially create the file.
extension MasterViewController{
    
    //MARK: Entry management methods
    
    func indexOfEntryWithFileURL(fileURL:NSURL) -> Int {
        //
        var retval = -1
        let entryArray = objects as NSArray
        //数组 ENUMERATE
        entryArray.enumerateObjectsUsingBlock { (entry, idx, stop) in
            //
            if(entry.fileURL == fileURL){
                //
                retval = idx
                stop.memory = true
            }
        }
        return retval
    }
    
    func addOrUpdateEntryWithURL(fileURL:NSURL,metadata:PTKMetadata,state:UIDocumentState,version:NSFileVersion) {
        let index = indexOfEntryWithFileURL(fileURL)
        //Not found, so add
        if(index == -1){
            let entry = PTKEntry.init(fileURL: fileURL, metadata: metadata, state: state, version: version)
            objects.append(entry)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: objects.count - 1, inSection: 0)], withRowAnimation: .Right)
        }else{
            //Found so edit
            let entry = objects[index] as! PTKEntry
            entry.metadata = metadata
            entry.state = state
            entry.version = version
            
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: index, inSection: 0)], withRowAnimation: .None)
        }
    }

}

//If you run the app again, nothing will show up in the list! That’s because we haven’t added the code to list documents yet, so let’s do that now.

//MARK: Listing Local Documents
extension MasterViewController{
    
    //the method that loads a document given a file URL.
    func loadDocAtURL(fileURL:NSURL) {
        // Open doc so we can read metadata
        let doc = PTKDocument.init(fileURL: fileURL)
        doc.openWithCompletionHandler { (success) in
            //check status
            if(!success){
                NSLog("Failed to open \(fileURL)")
                return
            }
            
            // preload metadata on background thread 
            let metadata = doc.metadata
            let fileURL = doc.fileURL
            let state = doc.documentState
            let version = NSFileVersion.currentVersionOfItemAtURL(fileURL)
            NSLog("Loaded File URL: \(doc.fileURL.lastPathComponent)")
            
            //Close since we are done with it 
            doc.closeWithCompletionHandler({ (success) in
                //
                if(!success){
                    NSLog("Failed to close \(fileURL)")
                }
                
                //Add to the list of files on main thread 
                dispatch_async(dispatch_get_main_queue(), { 
                    //
                    self.addOrUpdateEntryWithURL(fileURL, metadata: metadata!, state: state, version: version!)
                })
            })
        }
    }
    
    func loadLocal() {
        //
        let localDocuments = try! NSFileManager.defaultManager().contentsOfDirectoryAtURL(self.localRoot, includingPropertiesForKeys: nil, options: [])
        print("Found \(localDocuments.count) local files.")
        for i in 0..<localDocuments.count {
            //
            let fileURL = localDocuments[i]
            if fileURL.pathExtension == PTK_EXTENSION {
                //
                print("Found local file:\(fileURL)")
                loadDocAtURL(fileURL)
            }
        }
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func refresh() {
        //
        objects.removeAll()
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem?.enabled = true
        if iCloudOn() {
            //
            loadLocal()
        }
    }
}

