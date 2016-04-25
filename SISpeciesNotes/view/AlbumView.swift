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
        // 处理加载网络图片
        coverImage.af_setImageWithURL(NSURL.init(string: ablumCover)!,
                                      placeholderImage: UIImage(named: "barcelona-thumb"),
                                      filter: DynamicImageFilter("DynamicImage"){$0},
                                      progress: { (bytesRead, totalBytesRead, totalExpectedBytesToRead) in
            //
            },
                                      progressQueue: dispatch_get_main_queue(),
                                      imageTransition:UIImageView.ImageTransition.CurlUp(2),
                                      runImageTransitionIfCached: true) { response in
                                        //打印
                                        print(response.debugDescription)
        }
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
