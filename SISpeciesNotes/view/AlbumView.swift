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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
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
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .White
        indicator.startAnimating()
        addSubview(indicator)
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
