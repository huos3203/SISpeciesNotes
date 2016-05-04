//
//  NoteModel.swift
//  TextKitNotepad
//
//  Created by pengyucheng on 16/5/4.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation

class NoteModel{

    var contents:String
    var timetamp:NSDate
    
    init(newText:String){
        contents = newText
        timetamp = NSDate()
    }
    
    var title:String{
        let lines = contents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        return lines[0]
    }
}