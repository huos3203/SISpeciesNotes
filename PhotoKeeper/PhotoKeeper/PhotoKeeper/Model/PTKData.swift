//
//  PTKData.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/26.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation
import UIKit

/// this is a very simple model class that only has one piece of data to track – the full size photo. It implements the NSCoding protocol to encode/decode to a buffer of data.
class PTKData:NSObject, NSCoding {

    var photo:UIImage
    
    init(photo:UIImage) {
        //
        self.photo = photo
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        //
        
        aDecoder.decodeIntForKey(kVersionKey)
        let photoData = aDecoder.decodeObjectForKey(kPhotoKey)
        photo = UIImage.init(data: photoData as! NSData)!
        super.init()
    }
    
    let kVersionKey = "Version"
    let kPhotoKey = "Photo"
    func encodeWithCoder(aCoder: NSCoder) {
        //
        aCoder.encodeInt(1, forKey: kVersionKey)
        let photoData = UIImagePNGRepresentation(photo)
        aCoder.encodeObject(photoData,forKey: kPhotoKey)
        
    }
    
    
    
}
