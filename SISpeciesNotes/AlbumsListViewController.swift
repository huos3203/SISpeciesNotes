//
//  AlbumsListViewController.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/19.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import UIKit


/// 显示所有专辑列表
class AlbumsListViewController: UITableViewController {
    
    //存储变量
    //系列数组
    private var albums = [Album]()
    
    //详情页内容
    private var albumDetail:(title:String,value:String)?
    
    //周期方法
    override func viewDidLoad() {
        //获取数据
        albums = LibraryAPI().getAlbums()
        
        //初始化UI
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        //注册cell identifier
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    //协议方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    

}
