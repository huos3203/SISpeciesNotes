//
//  PTKData.swift
//  PhotoKeeper
//
//  Created by pengyucheng on 16/5/26.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation
import UIKit

//Note that it stores a version number along with the photo. This makes it easy to update the data structure if you want to in the future while still supporting older files. If you ever add a new field, you bump up the version number, then while decoding you can check the version number to see if the new field is available.
let kVersionKey = "Version"
let kPhotoKey = "Photo"

///This will be the main data of the document
//the full size photo. It implements the NSCoding protocol to encode/decode to a buffer of data.
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
    
    func encodeWithCoder(aCoder: NSCoder) {
        //
        aCoder.encodeInt(1, forKey: kVersionKey)
        let photoData = UIImagePNGRepresentation(photo)
        aCoder.encodeObject(photoData,forKey: kPhotoKey)
        
    }
    
    
    
}
