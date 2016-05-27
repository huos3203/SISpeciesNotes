//
//  PTKEntry.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/27.
//  Copyright © 2016年 recomend. All rights reserved.
//

import UIKit

/*  Store Entries
    Find an Available URL
    Create the Document
    Make Final Changes
*/
class PTKEntry: NSObject {

    var fileURL:NSURL
    var metadata:PTKMetadata
    var state:UIDocumentState
    var version:NSFileVersion
    
    init(fileURL:NSURL,metadata:PTKMetadata,state:UIDocumentState,version:NSFileVersion) {
        //
        self.fileURL = fileURL
        self.metadata = metadata
        self.state = state
        self.version = version
        super.init()
    }
    
    override var description: String{
        let lastPath = self.fileURL.lastPathComponent! as NSString
        return lastPath.stringByDeletingPathExtension
    }
}
