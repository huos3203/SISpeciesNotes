//
//  SpeciesAnnotation.swift
//  SISpeciesNotes
//
//  Created by 星夜暮晨 on 2015-04-29.
//  Copyright (c) 2015 益行人. All rights reserved.
//

import MapKit

///: #### 物种所属的标记信息
class SpeciesAnnotation:NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var category = Categories.Uncategorized
    
    init(coordinate: CLLocationCoordinate2D, title: String, sub: Categories) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = sub.rawValue
    }
    
}

/// 物种相关的枚举信息
///
/// 使用字符串类型作为原始值类型,如果没有明确指定字符串字面值，就会被枚举特性：原始值隐式赋值为成员名称的字面值
enum Categories: String {
    case Uncategorized = "未分类"
    case Insects = "昆虫"
    case Birds = "鸟类"
    case Mammals = "哺乳动物"
    case Flora = "植物"
    case Reptiles = "爬行动物"
    //MARK: - 初始化原始值数组
    ///使用枚举成员的rawValue属性可以访问该枚举成员的原始值
    static let allValues = [
        Uncategorized.rawValue,
        Insects.rawValue,
        Birds.rawValue,
        Mammals.rawValue,
        Flora.rawValue,
        Reptiles.rawValue
    ]
    
    //MARK: - 获取物种对应的标记图片
    /// 获取物种所对应的标记图片
    func getImage() -> UIImage {
        switch self {
        case .Birds:
            return UIImage(named: "IconBirds")!
        case .Flora:
            return UIImage(named: "IconFlora")!
        case .Insects:
            return UIImage(named: "IconInsects")!
        case .Mammals:
            return UIImage(named: "IconMammals")!
        case .Reptiles:
            return UIImage(named: "IconReptile")!
        case .Uncategorized:
            return UIImage(named: "IconUncategorized")!
        }
    }
}