//
//  Bicycle.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/1/28.
//  Copyright © 2016年 益行人. All rights reserved.
//

import Foundation



/// 🚲 一个两轮的，人力驱动的交通工具.
class Bicycle {
   /**  
     车架样式.
     
     - Road: 用于街道或步道.
     - Touring: 用于长途.
     - Cruiser: 用于城镇周围的休闲之旅.
     - Hybrid: 用于通用运输.
     */
    enum Style {
        case Road, Touring, Cruiser, Hybrid
    }
    
    /**
     转换踏板功率为运动的机制。
     
     - Fixed: 一个单一的，固定的齿轮。
     - Freewheel: 一个可变速，脱开的齿轮。
     */
    enum Gearing {
        case Fixed
        case Freewheel(speeds: Int)
    }
    
    /**
     用于转向的硬件。
     
     - Riser: 一个休闲车把。
     - Café: 一个正常车把。
     - Drop: 一个经典车把.
     - Bullhorn: 一个超帅车把.
     */
    enum Handlebar {
        case Riser, Café, Drop, Bullhorn
    }
    
    /// 自行车的风格
    let style: Style
    
    /// 自行车的齿轮
    let gearing: Gearing
    
    /// 自行车的车把
    let handlebar: Handlebar
    
    /// 车架大小, 厘米为单位.
    let frameSize: Int
    
    /// 自行车行驶的旅程数
    private(set) var numberOfTrips: Int
    
    /// 自行车总共行驶的距离，米为单位
    private(set) var distanceTravelled: Double
    
    /**
     使用提供的部件及规格初始化一个新自行车。
     
     :param: style 自行车的风格
     :param: gearing 自行车的齿轮
     :param: handlebar 自行车的车把
     :param: centimeters 自行车的车架大小，单位为厘米
     
     :returns: 一个漂亮的，全新的，为你度身定做.
     */
    init(style: Style, gearing: Gearing, handlebar: Handlebar, frameSize centimeters: Int) {
        self.style = style
        self.gearing = gearing
        self.handlebar = handlebar
        self.frameSize = centimeters
        
        self.numberOfTrips = 0
        self.distanceTravelled = 0
    }
    
    /**
     把自行车骑出去遛一圈
     
     :param: meters 行驶的距离，单位为米
     */
    func travel(distance meters: Double) {
        if meters > 0 {
            distanceTravelled += meters
            ++numberOfTrips
        }
    }
    
    /**
    练习：
     
     - 基本标记：
     
     ```
        文档注释通过使用 的单行注释来进行区分。在注释块里面，段落由空行分隔。无序列表可由多个项目符号字符组成：-、+、 *、 • 等，同时有序列表使用阿拉伯数字（1，2，3，...），后跟一个点符 1. 或右括号 1) 或两侧括号括起来 (1)
     ```
     
     - 定义与字段列表：
     
     ```
        两个特殊字段用于记录参数和返回值：分别为：:param: 和 :returns:。:param: 后跟的是参数的名称，然后是说明。返回值没有名字，所以 :returns: 后就是说明
     ```
     
     - 代码快:
     
     ```
        代码块也可以嵌入到文档的注释里，这对于演示正确的使用方式或实现细节很有用。用至少两个空格来插入代码块
     ```
     - 导航标记：
        
        MARK / TODO / FIXME
    */
    func hs(){
    
    }
    
    /**
     The perimeter of the `Shape` instance.
     
     Computation depends on the shape of the instance, and is
     equivalent to:
     
     ```
     // Circles:
     let perimeter = circle.radius * 2 * CGFloat(M_PI)
     
     // Other shapes:
     let perimeter = shape.sides.map { $0.length }
     .reduce(0, combine: +)
     ```
     */
    var perimeter: CGFloat { get }
    
}