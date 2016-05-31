//
//  PTKMetadata.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/27.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation
import UIKit

let kThumbnailKey = "Thumbnail"

// This will be anything the master view controller needs to display a preview. the purpose of this class is so we can store a much smaller thumbnail version of the photo that will load quickly in the master view controller.

// This is pretty much exactly the same as PTKData,We even could have used the same class, but it’s better to keep things separate in case we need more data fields in the future

class PTKMetadata: NSObject,NSCoding {

    var thumbnail:UIImage
    
    init(thumbnail:UIImage) {
        //
        self.thumbnail = thumbnail
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        //
        aDecoder.decodeIntForKey(kVersionKey)
        let thumbnailData = aDecoder.decodeObjectForKey(kThumbnailKey)
        thumbnail = UIImage.init(data: thumbnailData as! NSData)!
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        //
        aCoder.encodeInt(1, forKey: kVersionKey)
        let thumbnailData = UIImagePNGRepresentation(thumbnail)
        aCoder.encodeObject(thumbnailData,forKey: kThumbnailKey)
        
    }

}
