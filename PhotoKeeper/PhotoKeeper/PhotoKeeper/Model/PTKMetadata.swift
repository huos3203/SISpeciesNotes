//
//  PTKMetadata.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/27.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation
import UIKit

/// the purpose of this class is so we can store a much smaller thumbnail version of the photo that will load quickly in the master view controller,
///This is pretty much exactly the same as PTKData, so no need to discuss further here. We even could have used the same class, but it’s better to keep things separate in case we need more data fields in the future
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
    
    /// This makes it easy to update the data structure if you want to in the future while still supporting older files
    /// If you ever add a new field, you bump up the version number, then while decoding you can check the version number to see if the new field is available.
    let kVersionKey = "Version"
    let kThumbnailKey = "Thumbnail"
    func encodeWithCoder(aCoder: NSCoder) {
        //
        aCoder.encodeInt(1, forKey: kVersionKey)
        let thumbnailData = UIImagePNGRepresentation(thumbnail)
        aCoder.encodeObject(thumbnailData,forKey: kThumbnailKey)
        
    }

}
