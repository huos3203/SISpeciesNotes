//
//  AppDelegate.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-29.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //设置realm数据库迁移配置
        setRealmConfiguration()
        
        //从代码中启动UI界面
//        launchAPPWithoutStoryBoard()
        
            return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //不通过Storyboard作为加载UI视图界面的相关代码
    func launchAPPWithoutStoryBoard()
    {
        //实例化window
        self.window = UIWindow(frame:UIScreen.main.bounds)
        //组装导航控制器
        let loginViewController = LoginViewController() //
        let albums = AlbumsListViewController()
        let navigationController = UINavigationController(rootViewController:albums)
        
        //安装导航控制器
        self.window?.rootViewController = navigationController
        
        //启动加载
        self.window!.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
    }
    
    
    
    
    //设置Reaml数据库升级的相关配置
    func setRealmConfiguration()
    {
        // 在(application:didFinishLaunchingWithOptions:)中调用
        let config = Realm.Configuration(
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: 1,
            
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
        
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
        
        // 现在我们已经告诉了 Realm 如何处理架构的变化，打开文件之后将会自动执行迁移
//        let realm = try! Realm()

    }


}

