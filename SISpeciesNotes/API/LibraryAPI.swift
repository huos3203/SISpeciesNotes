//
//  LibraryAPI.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/3/14.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

//外观模式（Facade）作为专辑管理类的入口
//只让 LibraryAPI 持有 PersistencyManager 和 HTTPClient 的实例，
//然后 LibraryAPI 暴露一个简单的接口给其他类来访问，这样外部的访问类不需要知道内部的业务具体是怎样的，也不用知道你是通过 PersistencyManager 还是 HTTPClient 获取到数据的。
class LibraryAPI: NSObject
{
    //创建一个属于自己类型的计算类型的类变量
    class var shareInstance:LibraryAPI{

//单例模式的应用还有另一种情况：你需要一个全局类来处理配置文件
        /// 单例模式确保每个指定的类只存在一个实例对象，并且可以全局访问那个实例。
        //1. 一般情况下会使用延时加载的策略(static静态修饰符)，意味着 Instance 直到需要的时候才会被创建
        //2. 只在第一次需要使用的时候初始化(let常量)。一旦创建之后不会再创建第二次
        
        //嵌套一个 Singleton 结构体
        struct Singleton{
            //定义一个存储类型的类常量，
            static let instance = LibraryAPI()
        }
        return Singleton.instance
    }
    
//现在用 PersistencyManager 来管理专辑数据，
//用 HTTPClient 来处理网络请求，项目中的其他类不应该知道这个逻辑。
//用户只需要知道 LibraryAPI 这个“外观”就可以了
    //创建实例
    fileprivate let persistency:PersistencyManager
    fileprivate let httpClient:HttpClientManager
    fileprivate let localFile:LocalFileManager
    fileprivate let isOnline: Bool    //标识当前是否为联网状态的，如果是联网状态就会去网络获取数据。
    
    //构造器
    override init(){
        
        persistency = PersistencyManager()
        httpClient = HttpClientManager()
        localFile = LocalFileManager()
        isOnline = false

        super.init()

        /**
         现象：在加载图片时，albumView发出的广播，LibraryAPI无法收到通知....
         问题：由于albums = LibraryAPI().getAlbums()
         解决：必须使用单例模式：albums = LibraryAPI.shareInstance.getAlbums()
         */
        NotificationCenter.default.addObserver(self, selector: #selector(LibraryAPI.DowdloadImage(_:)), name: NSNotification.Name(rawValue: "BLDownloadImageNotification"), object: nil)
    }
    
    //MARK: - 外观方法
   
    //获取专辑
    func getAlbums()->[Album]
    {
        return persistency.getAlbums()
    }

    
//看一下 addAlbum(_:index:) 这个方法，先更新本地缓存，然后如果是联网状态还需要向服务器发送网络请求。
//这便是外观模式的强大之处：如果外部文件想要添加一个新的专辑，它不会也不用去了解内部的实现逻辑是怎么样的。
    //添加专辑
    func addAlbum(_ album:Album, index:Int) {
        //
        persistency.addAlbum(album, index: index)
        if isOnline
        {
            httpClient.addAlbum(album, index: index)
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - 通知方法 
    //下载图片
    func DowdloadImage(_ notification:Notification){
        
        let ueserInfo = notification.userInfo as! [String:AnyObject]
        let imagePath = ueserInfo["imageUrl"] as! String
        var coverImageView = ueserInfo["coverImage"] as! UIImageView
        
        coverImageView.image = UIImage(named: "barcelona-thumb")
        //缓存文件
        if !localFile.fileExists(atPath: imagePath){
            //网络下载数据
            httpClient.downloadCoverImage(imagePath as NSString){location in
                //以图片格式保存到本地
                let imageDocPath = self.localFile.saveImageToDocument(location, imageURL: imagePath)
                coverImageView.image = UIImage.init(contentsOfFile: imageDocPath)
            }
        }else{
            let localImagePath = localFile.createDocumentPathFrom(imagePath as NSString)
            coverImageView.image = UIImage.init(contentsOfFile: localImagePath)
        }
        
    }
    
   
}
