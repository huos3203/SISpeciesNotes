//
//  Panagram.swift
//  Panagram
//
//  Created by pengyucheng on 16/6/15.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation

class Panagram {
    //
    let consoleIO = ConsoleIO()
    func staticMode() {
        //
//        ConsoleIO.printUsage()
        //1. get the number of arguments passed to the program.
        let argCount = Process.argc
        //2.  take the first “real” argument from the arguments array.
        let argument = Process.arguments[1]
        //3. parse the argument and convert it to an OptionType.
        let (option,value) = consoleIO.getOption(argument.substringFromIndex(argument.startIndex.advancedBy(1)))
        
        //4. log the parsing results to the console.
        print("Argument count:\(argCount) Option:\(option) value:\(value)")
    }
}