//
//  AlbumsListViewController.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/19.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import UIKit


/// 显示所有专辑列表
public class AlbumsListViewController: UITableViewController {
    
    //存储变量
    //系列数组
    private var albums = [Album]()
    
    //详情页内容
    private var albumDetail:(title:String,value:String)?
    
    //周期方法
    override public func viewDidLoad() {
        //获取数据
        albums = LibraryAPI().getAlbums()
        
        //初始化UI
//        tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
        
        //注册cell identifier
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //MARK: - datasource
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = albums[indexPath.row].title
        cell?.detailTextLabel?.text = albums[indexPath.row].artist
        
        return cell!
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let name = albums[indexPath.row].title
        print("点击....\(name)")
        let alertView = UIAlertController.init(title: "测试", message: "当前点击的Cell：\(name)", preferredStyle: .Alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel) { _ in
            //取消
            print("隐藏提示框....\(name)")
        }
        
        alertView.addAction(cancelAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    

}
