//
//  BicycleExtension.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/1/28.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

// MARK: Printable
extension BicycleExtension: Printable
{
    
    var description: String {
        var descriptors: [String] = []
        
        switch self.style {
        case .Road:
            descriptors.append("A road bike for streets or trails")
        case .Touring:
            descriptors.append("A touring bike for long journeys")
        case .Cruiser:
            descriptors.append("A cruiser bike for casual trips around town")
        case .Hybrid:
            descriptors.append("A hybrid bike for general-purpose transportation")
        }
        
        switch self.gearing {
        case .Fixed:
            descriptors.append("with a single, fixed gear")
        case .Freewheel(let n):
            descriptors.append("with a \(n)-speed freewheel gear")
        }
        
        switch self.handlebar {
        case .Riser:
            descriptors.append("and casual, riser handlebars")
        case .Café:
            descriptors.append("and upright, café handlebars")
        case .Drop:
            descriptors.append("and classic, drop handlebars")
        case .Bullhorn:
            descriptors.append("and powerful bullhorn handlebars")
        }
        
        descriptors.append("on a \(frameSize)\" frame")
        
        // FIXME: - 使用格式化的距离
        descriptors.append("with a total of \(distanceTravelled) meters traveled over \(numberOfTrips) trips.")
        
        // TODO: - 允许自行车被命名吗？
        
        return join(", ", descriptors)
    }

}
