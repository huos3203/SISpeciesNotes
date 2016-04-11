//
//  SpeciesModel.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 15/12/16.
//  Copyright © 2015年 益行人. All rights reserved.
//

import Foundation
import RealmSwift

/// 对应realm数据库物种信息表的模型
/// 对于 Realm 中的一些特定的数据类型，比如说字符串，必须要初始化

class SpeciesModel: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    
    ///物种名称
    dynamic var name = ""
    ///物种的描述信息
    dynamic var speciesDescription = ""
    ///纬度信息
    dynamic var latitude: Double = 0
    ///经度
    dynamic var longitude: Double = 0
    ///创建的时间
    dynamic var created = NSDate()
    
    /// 设置了 “ 物种 ” 和 “ 类别 ” 之间的 “ 一对多 ” 关系.每个物种都只能够拥有一个类别，但是一个类别可以从属于多个物种。
    
    /**
    `Shape` 实例的面积.
    
    计算取决于该实例的形状。如果是三角形，`area` 将相当于:
    
        let height = triangle.calculateHeight()
        let area = triangle.base * height / 2
    */
    dynamic var category:CategoryModel? = CategoryModel()
    
//    索引
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
//    主键
    dynamic var specieId = 0
    override static func primaryKey() -> String?
    {
        return "specieId"
    }
    
    
}
