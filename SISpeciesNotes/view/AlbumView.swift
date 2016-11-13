//
//  AlbumView.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/3/14.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit
//专辑视图模型
class AlbumView: UIView {
    
//    封面，加载进度条
    fileprivate var coverImage:UIImageView!
    fileprivate var indicator:UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect,ablumCover:String) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.black
        coverImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        //添加观察者
        coverImage.addObserver(self, forKeyPath: "image", options: [], context: nil)
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .gray
        indicator.startAnimating()
        addSubview(indicator)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "BLDownloadImageNotification"), object: self, userInfo: ["coverImage":coverImage,"imageUrl":ablumCover])
    }
    
    //当coverImage变化时触发
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "image" {
            indicator.stopAnimating()
        }
    }
    
    deinit{
        coverImage.removeObserver(self, forKeyPath: "image")
    }
//    
    func highlightAlbum(didHighlightView:Bool)
    {
        if(didHighlightView)
        {
            backgroundColor = UIColor.white
        }else
        {
            backgroundColor = UIColor.black
        }
    }

}
