//
//  PTKDocument.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/27.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation
import UIKit

//Even though NSFileWrapper is basically a directory, we still need to give it a file extension so we can identify the directory as a document our app knows how to handle. use “ptk” as our file extension, so we define it here for easy access later.
let PTK_EXTENSION = "ptk"

//define the filenames for the two sub-files that will be inside our directory/NSFileWrapper.
let METADATA_FILENAME = "photo.metadata"
let DATA_FILENAME = "photo.data"

/*
 UIDocument is built around the concept of undo/redo – it has an undo manager and when you make changes UIDocument can auto-save in the background。
 
Subclassing UIDocument
 Input/Output Formats
 UIDocument supports two different classes for input/output:
 1. NSData: This represents a simple buffer of data, which is good when your document is just a single file.
 2. NSFileWrapper: This represents a directory of file packages, which the OS treats as a single file. This is good for when your document consists of multiple files that you want to be able to load independently.
*/

//PTKDocument will combine the data and metadata into a single NSFileWrapper.
class PTKDocument: UIDocument {
    
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
    
    //MARK: - Override Document
    
    //write : Think of this as “write the document”. You encode your internal model to an output class.
    /**
     create a directory NSFileWrapper
     
     - parameter typeName: typeName
     
     - throws: ErrorType
     
     - returns: fileWrapper
     */
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

    //read : Think of this as “read the document”. You get an input class, and you have to decode it to your internal model.
    func loadFromContents(contents:AnyObject,typeName:String,outError:ErrorType) -> Bool {
        //
        self.fileWrapper = contents as? NSFileWrapper
        
        // The rest will be lazy loaded...
        self.data = nil
        self.metadata = nil
        return true
    }
    
    //
    override var description: String{
        get{
            let lastPath = self.fileURL.lastPathComponent! as NSString
            return lastPath.stringByDeletingPathExtension
        }
    }
    

    
    //MARK: - Helper
    //MARK: write the UIDocument to disk : create a file NSFileWrapper for the data and metadata
    func encodeObject(object:NSCoding,inout toWrappers wrappers:[String:NSFileWrapper], preferredFilename:String) {
        //
        let data = NSMutableData.init()
        // 1. uses the NSKeyedArchiver class to convert the object that implements NSCoding into a data buffer.
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: data)
        archiver.encodeObject(object, forKey: "data")
        archiver.finishEncoding()
        // 2. creates a file NSFileWrapper with the buffer and adds it to the dictionary.
        let wrapper = NSFileWrapper.init(regularFileWithContents: data)
        wrappers.updateValue(wrapper, forKey: preferredFilename)
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
}

enum Error:ErrorType {
    case error1
    case error2
}
