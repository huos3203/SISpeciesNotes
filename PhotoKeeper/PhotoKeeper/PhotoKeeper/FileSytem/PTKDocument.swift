//
//  PTKDocument.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/27.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation
import UIKit

let PTK_EXTENSION = "ptk"
let METADATA_FILENAME = "photo.metadata"
let DATA_FILENAME = "photo.data"

//create a subclass of UIDocument that will combine the data and metadata into a single NSFileWrapper
class PTKDocument: UIDocument {

    //Even though NSFileWrapper is basically a directory, we still need to give it a file extension so we can identify the directory as a document our app knows how to handle. use “ptk” as our file extension, so we define it here for easy access later.
    
    
    //data
    var photo:UIImage{
        
        get{
            return self.data!.photo
        }
        set(newPhoto){
            self.data?.photo = newPhoto
            self.metadata?.thumbnail = (self.data?.photo.imageByScalingAndCroppingForSize(CGSizeMake(145, 145)))!
            self.undoManager.setActionName("Image Change")
            //Swift doesn't know about the ObjC accessors for property getter/setter pairs. So, for example, given a var foo: Int, there isn't a func setFoo(_:) that you can construct a #selector from, even though there is a Selector(setFoo:)
            self.undoManager.registerUndoWithTarget(self, selector: Selector("setPhoto:"), object: newPhoto)
        }
    
    }
    
    // Metadata
    var metadata:PTKMetadata? {
    
        get{
            if let _ = self.metadata {
                return self.metadata
            }
            
            if let _ = fileWrapper{
                
                self.metadata = self.decodeObjectFromWrapper(METADATA_FILENAME) as? PTKMetadata
            } else{
                 self.metadata = PTKMetadata.init(thumbnail: photo)
            }
            return self.metadata
        }
        
        set{
        
        }
        
    }
    var data:PTKData?{
    
        get{
            if let _ = self.data {
                //
                return self.data
            }
            
            if let _ = fileWrapper {
                //
                self.data = decodeObjectFromWrapper(DATA_FILENAME) as? PTKData
            }else{
                self.data = PTKData.init(photo: photo)
            }
            return self.data
        }
        
        set{}
    }

    //the class that treats the directory as a single file
    var fileWrapper:NSFileWrapper? = nil
    
    override init(fileURL url: NSURL) {
        //
        super.init(fileURL: url)
    }
    
     //MARK: write the UIDocument to disk:
    func encodeObject(object:NSCoding,inout toWrappers wrappers:[String:NSFileWrapper], preferredFilename:String) {
        //
        let data = NSMutableData.init()
        //uses the NSKeyedArchiver class to convert the object that implements NSCoding into a data buffer.
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: data)
        archiver.encodeObject(object, forKey: "data")
        archiver.finishEncoding()
        //creates a file NSFileWrapper with the buffer and adds it to the dictionary.
        let wrapper = NSFileWrapper.init(regularFileWithContents: data)
        wrappers.updateValue(wrapper, forKey: preferredFilename)
    }
   
    override func contentsForType(typeName: String) throws -> AnyObject {
        //
        guard let _ = metadata,let _ = data else{
            throw Error.error1
        }
        var wrappers = [String:NSFileWrapper]()
        encodeObject(metadata!, toWrappers: &wrappers, preferredFilename: METADATA_FILENAME)
        encodeObject(data!, toWrappers: &wrappers, preferredFilename: DATA_FILENAME)
        //you call initDirectoryWithFileWrapper and pass in a dictionary that contains file NSFileWrappers as the objects, and the names of the files as the key.
        let fileWrapper = NSFileWrapper.init(directoryWithFileWrappers: wrappers)
        
        return fileWrapper
    }
    
    
    //MARK: reading
    func decodeObjectFromWrapper(preferredFileName:String)->AnyObject{
    
        let fileWrapper = self.fileWrapper?.fileWrappers![preferredFileName]
        if (fileWrapper != nil) {
            //
            NSLog("Unexpected error: Couldn't find %@ in file wrapper!", preferredFileName)
            return 0
        }
        let data = self.fileWrapper?.regularFileContents!
        let unarchiver = NSKeyedUnarchiver.init(forReadingWithData: data!)
        return unarchiver.decodeObjectForKey("data")!
    }
    
    
    func loadFromContents(contents:AnyObject,typeName:String,outError:ErrorType) -> Bool {
        //
        self.fileWrapper = contents as? NSFileWrapper
        
        // The rest will be lazy loaded...
        self.data = nil
        self.metadata = nil
        return true
    }
    
    override var description: String{
        get{
            let lastPath = self.fileURL.lastPathComponent! as NSString
            return lastPath.stringByDeletingPathExtension
        }
    }

    
}

enum Error:ErrorType {
    case error1
    case error2
}
