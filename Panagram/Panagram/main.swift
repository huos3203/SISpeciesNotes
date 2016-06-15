//
//  main.swift
//  Panagram
//
//  Created by pengyucheng on 16/6/15.
//  Copyright © 2016年 recomend. All rights reserved.
//

//Swift doesn’t have a main function; instead, it has a main file.
import Foundation

let panagram = Panagram()

if Process.argc < 2{
    //Handle interactive mode
    panagram.interactiveMode()
}else{
    panagram.staticMode()
}