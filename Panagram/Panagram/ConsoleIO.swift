//
//  ConsoleIO.swift
//  Panagram
//
//  Created by pengyucheng on 16/6/15.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation

class ConsoleIO{
    
    //prints usage information to the console
    class func printUsage(){
        //Process is a small wrapper around the argc and argv arguments you may know from C-like languages
        let executableName = (Process.arguments[0] as NSString).lastPathComponent
        print("usage:")
        print("\(executableName) -a string1 string2")
        print("or")
        print("\(executableName) -p string")
        print("or")
        print("\(executableName) -h to show usage information")
        print("Type \(executableName) without an option to enter interactive mode.")
    }
}