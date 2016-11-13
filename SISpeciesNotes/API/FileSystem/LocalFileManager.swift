//
//  LocalFileManager.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/28.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//


class LocalFileManager: FileManager {

    override init() {
        super.init()
    }
    //文件本地路径Document目录
    func createDocumentPathFrom(_ filePath:NSString) -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return docPath + filePath.lastPathComponent
    }
    
    //检查文件是否已存在
   override func fileExists(atPath path: String) -> Bool {
        //
        let filePath = createDocumentPathFrom(path as NSString)
        return super.fileExists(atPath: filePath)
    }
    
    //保存到本地
    func saveImageToDocument(_ tmpUrl:URL,imageURL:String)->String  {
        //
        let docpath = createDocumentPathFrom(imageURL as NSString)
        let imageData = try? Data(contentsOf: tmpUrl)
        try? imageData?.write(to: URL(fileURLWithPath: docpath), options: [.atomic])
        return docpath
    }
}
