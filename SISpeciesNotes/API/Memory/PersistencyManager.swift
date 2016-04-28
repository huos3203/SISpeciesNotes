//
//  PersistencyManager.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/18.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

/// 一个处理专辑数据持久化的类
class PersistencyManager {
    
    //定义了一个私有属性，用来存储专辑数据
    private var albums = [Album]()
    //初始化数据
    init() {
        //
        //Dummy list of albums
        let album1 = Album(title: "Best of Bowie",
                           artist: "David Bowie",
                           gener: "Pop",
                           coverUrl: "http://huos3203.github.io/MyBlog/images/QQ20160114-0.png",
                           year: "1992")
        
        let album2 = Album(title: "It's My Life",
                           artist: "No Doubt",
                           gener: "Pop",
                           coverUrl: "http://huos3203.github.io/MyBlog/images/vIfAjiY.png!web.png",
                           year: "2003")
        
        let album3 = Album(title: "Nothing Like The Sun",
                           artist: "Sting",
                           gener: "Pop",
                           coverUrl: "http://huos3203.github.io/MyBlog/images/IMG_0028.JPG",
                           year: "1999")
        
        let album4 = Album(title: "Staring at the Sun",
                           artist: "U2",
                           gener: "Pop",
                           coverUrl: "http://huos3203.github.io/MyBlog/images/QQ20160114-1.png",
                           year: "2000")
        
        let album5 = Album(title: "American Pie",
                           artist: "Madonna",
                           gener: "Pop",
                           coverUrl: "http://huos3203.github.io/MyBlog/images/QbMJNrM.png!web.png",
                           year: "2000")
        
        albums = [album1, album2, album3, album4, album5]
    }
    
    //查询
    func getAlbums()->[Album]{
        return albums
    }
    
    //添加专辑
    func addAlbum(album:Album,index:Int){
        if albums.count >= index {
            //
            albums.insert(album, atIndex: index)
        }else{
            albums.append(album)
        }
    }
    
    //删除操作
    func deleteAlbum(index:Int) {
        //
        albums.removeAtIndex(index)
    }
}
