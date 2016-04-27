//
//  AlbumView.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/3/14.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit
import AlamofireImage
//专辑视图模型
class AlbumView: UIView {
    
//    封面，加载进度条
    private var coverImage:UIImageView!
    private var indicator:UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect,ablumCover:String) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.blackColor()
        coverImage = UIImageView.init(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        //添加观察者
        coverImage.addObserver(self, forKeyPath: "image", options: [], context: nil)
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .White
        indicator.startAnimating()
        addSubview(indicator)
        
        NSNotificationCenter.defaultCenter().postNotificationName("DownloadImage", object: self, userInfo: ["coverImage":coverImage,"imageUrl":ablumCover])
    }
    
    //当coverImage变化时触发
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "image" {
            indicator.stopAnimating()
        }
    }
    
    deinit{
        coverImage.removeObserver(self, forKeyPath: "image")
    }
//    
    func highlightAlbum(didHighlightView didHighlightView:Bool)
    {
        if(didHighlightView)
        {
            backgroundColor = UIColor.whiteColor()
        }else
        {
            backgroundColor = UIColor.blackColor()
        }
    }

}
