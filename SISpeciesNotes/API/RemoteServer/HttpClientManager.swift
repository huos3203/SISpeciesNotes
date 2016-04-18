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
}
