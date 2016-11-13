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
    func addAlbum(_ album:Album,index:Int){
        Alamofire.request(URLRequest(url: URL(string: "/api/addAlbum")!))
    }
    
    //删除专辑
    func deleteAlbum(_ index:Int){
        Alamofire.request(URLRequest(url: URL(string: "/api/delAlbum")!))
    }
    
    
    
    
    //下载专辑封面,并返回文件本地路径
    func downloadCoverImage(_ filePath:NSString ,complection:@escaping (URL)->()){
        
        let fileUrl = URL(string: filePath as String)
        let coverSession = URLSession.shared.downloadTask(with: fileUrl!, completionHandler: { (location, response, error) in
            //完成
            if (location != nil){
                complection((location)!)
            }
        }) 
        coverSession.resume()
    }
    
}
