//
//  LocalFileManager.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/28.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//


class LocalFileManager: NSFileManager {

    override init() {
        super.init()
    }
    //文件本地路径Document目录
    func createDocumentPathFrom(filePath:NSString) -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return docPath.stringByAppendingString(filePath.lastPathComponent)
    }
    
    //检查文件是否已存在
   override func fileExistsAtPath(path: String) -> Bool {
        //
        let filePath = createDocumentPathFrom(path)
        return super.fileExistsAtPath(filePath)
    }
    
    //保存到本地
    func saveImageToDocument(tmpUrl:NSURL,imageURL:String)->String  {
        //
        let docpath = createDocumentPathFrom(imageURL)
        let imageData = NSData(contentsOfURL: tmpUrl)
        imageData?.writeToFile(docpath, atomically: true)
        return docpath
    }
}
