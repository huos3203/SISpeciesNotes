//
//  Album.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/3/14.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

//专辑
class Album: NSObject
{
    var title:String!
//    艺术家
    var artist:String!
//    派系
    var gener:String!
//封面
    var coverUrl:String!
//    年份
    var year:String!
    
//    构造方法
    init(title:String,artist:String,gener:String,coverUrl:String,year:String) {
        super.init()
        self.title = title
        self.artist = artist
        self.gener = gener
        self.coverUrl = coverUrl
        self.year = year
    }

//    专辑描述
    override var description:String{
    return "title:\(title)" +
            "artist:\(artist)" +
            "gener:\(gener)" +
            "coverUrl:\(coverUrl)" +
            "year:\(year)"
    }
}
