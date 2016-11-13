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

// MARK: - 装饰模式：扩展优点
//我们可以直接在扩展里使用 Album 里的属性。
//我们给 Album 类添加了内容但是并没有继承它，事实上，使用继承来扩展业务也可以实现一样的功能。
//这个简单的扩展让我们可以更好地把 Album 的数据展示在 UITableView 里，而且不用修改源码。
extension Album{

    //扩展一个提供支持展示专辑的方法
    func ae_TableRepresentation()->(titles:[String],values:[String?]) {
        //
        let titles = ["Artist","title","gener","year"]
        let values = [artist,title,gener,year]
        return (titles,values)
        
    }
}
