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
        let docPath = NSSearchPathForDirectoriesInDomains(.UserDirectory, .UserDomainMask, true)[0]
        return docPath.stringByAppendingString(filePath.lastPathComponent)
    }
    
    //检查文件是否已存在
   override func fileExistsAtPath(path: String) -> Bool {
        //
        let filePath = createDocumentPathFrom(path)
        print("documentPath:\(path)")
        return super.fileExistsAtPath(filePath)
    }
    
    override func copyItemAtPath(srcPath: String, toPath dstPath: String) throws {
        //
        let dst = createDocumentPathFrom(srcPath)
        try super.copyItemAtPath(srcPath, toPath: dst)
    }
}
