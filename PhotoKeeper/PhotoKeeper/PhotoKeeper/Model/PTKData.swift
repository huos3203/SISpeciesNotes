//
//  PTKData.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/26.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation
import UIKit

class PTKData:NSObject, NSCoding {

    var thumbnail:UIImage?
    
    init(thumbnail:UIImage) {
        //
        super.init()
        self.thumbnail = thumbnail
    }
    required init?(coder aDecoder: NSCoder) {
        //
        super.init()
        aDecoder.decodeIntForKey(kVersionKey)
        let thumbnailData = aDecoder.decodeObjectForKey(kThumbnailKey)
        thumbnail = UIImage.init(data: thumbnailData as! NSData)
    }
    
    let kVersionKey = "Version"
    let kThumbnailKey = "Thumbnail"
    func encodeWithCoder(aCoder: NSCoder) {
        //
        
        aCoder.encodeInt(1, forKey: kVersionKey)
        let thumbnailData = UIImagePNGRepresentation(thumbnail!)
        aCoder.encodeObject(thumbnailData,forKey: kThumbnailKey)
        
    }
    
    
    
}
