//
//  HttpClientManager.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/18.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import Alamofire

//使用HttpClient对象来与服务器通过HTTP进行交流
class HttpClientManager {
    
    //Alamofire
//    private let alamofire:Alamofire

    
    //添加专辑
    func addAlbum(album:Album,index:Int){
        Alamofire.request(NSURLRequest(URL: NSURL(string: "/api/addAlbum")!))
    }
    
    //删除专辑
    func deleteAlbum(index:Int){
        Alamofire.request(NSURLRequest(URL: NSURL(string: "/api/delAlbum")!))
    }
    
    
    
    
    //下载专辑封面,并返回文件本地路径
    func downloadCoverImage(filePath:NSString ,complection:(String)->()) -> NSURL{
        //
        print("下载文件：\(filePath)")
        var fileUrl = NSURL(string: filePath as String)
        let coverSession = NSURLSession.sharedSession().downloadTaskWithURL(fileUrl!) { (location, response, error) in
            //
            print("下载文件...error:\(error?.localizedDescription)")
            print("本地文件路径:\(location?.absoluteString)")
            fileUrl = location
            //完成
            complection((location?.absoluteString)!)
        }
        coverSession.resume()
        return fileUrl!
    }
    
}
