//
//  AlbumsListViewController.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/19.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import UIKit


/// 显示所有专辑列表
public class AlbumsListViewController: UIViewController {
    
    //存储变量
    private var tableView = UITableView()
    private var scroller = HorizontalScroller()
    //系列数组
    private var albums = [Album]()
    
    //详情页内容
    private var albumDetail:(title:String,value:String)?
    
    //周期方法
    override public func viewDidLoad() {
        //获取数据
        albums = LibraryAPI().getAlbums()
        
        //轮播图
        scroller.scrollerDataSource = self
        scroller.scrollerDelegate = self
        view.addSubview(scroller)
        scroller.snp_makeConstraints { (make) in
            //
            make.top.left.right.equalTo(view).inset(8)
        }
        
        //TableView协议
        tableView.delegate = self
        tableView.dataSource = self
        //注册cell identifier
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            //
            make.left.right.bottom.equalTo(view).inset(8)
            make.top.equalTo(scroller).inset(0)
        }
    }
}

// MARK: - 修饰模式，使用扩展来实现表格控制器相关的委托方法
extension AlbumsListViewController:UITableViewDelegate{
    //代理tableView点击某个单元格的事件
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //提示点击了某个单元格
        let alertView = UIAlertController.init(title: "代理事件", message: "点击对象是：\(albums[indexPath.row].artist)", preferredStyle: .Alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "确定", style: .Destructive) { _ in
            //默认消失...
            print("点击OK")
        }

        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}
extension AlbumsListViewController:UITableViewDataSource{
    
    //告诉tableView在这个类的表格中，每一行单元格的显示样式和内容
     public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //样式
        //通过Identifier来复用单元格
        var cellView = tableView.dequeueReusableCellWithIdentifier("cell")
        if cellView != nil {
            //新建cell
            cellView = UITableViewCell.init(style: .Value1, reuseIdentifier: "cell")
        }
        
        cellView?.textLabel?.text = albums[indexPath.row].title
        cellView?.detailTextLabel?.text = albums[indexPath.row].artist
        
        return cellView!
    }
    
    //告诉tableView每个单元中要显示cell的个数
     public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

}

// MARK: - 修饰模式，使用扩展来实现scroller相关委托
extension AlbumsListViewController:HorizontalScrollerDataSource{
    
    public func pageNumOfScroller() -> Int {
        return albums.count
    }
    
    public func horizontalScroller(scroller: UIScrollView, imageViewIndex: Int) -> UIImageView {
        //自定义ImageView
        
        
        return nil
    }
}
extension AlbumsListViewController:HorizontalScrollerDelegate{
    
    public func onclickPageImageView(imageView: UIImageView) {
        //点击事件
    }
}
