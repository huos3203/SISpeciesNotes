//
//  ConsoleIO.swift
//  Panagram
//
//  Created by pengyucheng on 16/6/15.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Foundation

//Panagram has three options: -p to detect palindromes, -a for anagrams and -h to show the usage information.
enum OptionType:String {
    case Palindrome = "p"
    case Anagram = "a"
    case Help = "h"
    case Unknown
    
    init(value:String){
        switch value {
        case "a":
            self = .Anagram
        case "p":
            self = .Palindrome
        case "h":
            self = .Help
        default:
            self = .Unknown
        }
    }
}

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
    
    //accepts a String as its argument and returns a tuple of OptionType and String.
    func getOption(option:String) -> (option:OptionType,value:String) {
        //
        return (OptionType(value:option),option)
    }

}