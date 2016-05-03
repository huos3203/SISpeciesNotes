//
//  MementoManager.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/5/3.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import Foundation

class MementoManager{


    /**
     存储轮播图状态
     saveCurrentState 把当前相册的索引值存到 NSUserDefaults 里。NSUserDefaults 是 iOS 提供的一个标准存储方案，用于保存应用的配置信息和数据。
     
     - parameter currentAlbumIndex: <#currentAlbumIndex description#>
     */
    func saveCurrentState(currentAlbumIndex:Int) {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        NSUserDefaults.standardUserDefaults().setInteger(currentAlbumIndex, forKey: "currentAlbumIndex")
    }
    
    /**
     加载轮播图状态
     loadPreviousState 方法加载上次存储的索引值。这并不是备忘录模式的完整实现，但是已经离目标不远了
     
     - returns: <#return value description#>
     */
    func loadPreviousState()->Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("currentAlbumIndex")
    }
}