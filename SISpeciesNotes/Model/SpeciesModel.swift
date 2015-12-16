//
//  SpeciesModel.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 15/12/16.
//  Copyright © 2015年 益行人. All rights reserved.
//

import Foundation
import Realm

class SpeciesModel: RLMObject {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var name = ""      //物种名称
    
    dynamic var speciesDescription = ""   //物种的描述信息
    dynamic var latitude: Double = 0       //纬度信息
    dynamic var longitude: Double = 0    //经度
    dynamic var created = NSDate()       //创建的时间
    dynamic var category = CategoryModel()
}
