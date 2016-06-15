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
        //1. get the number of arguments passed to the program.
        let argCount = Process.argc
        //2.  take the first “real” argument from the arguments array.
        let argument = Process.arguments[1]
        //3. parse the argument and convert it to an OptionType.
        let (option,value) = consoleIO.getOption(argument.substringFromIndex(argument.startIndex.advancedBy(1)))
        
        //4. log the parsing results to the console.
//        print("Argument count:\(argCount) Option:\(option) value:\(value)")
        
        //1. First, switch to see what should be detected.
        switch option {
        case .Anagram:
            //2 there must be four command-line arguments passed in.
            if argCount != 4 {
                if argCount > 4 {
                    //
                    print("Too many arguments for option \(option.rawValue)")
                }else{
                    print("Too few arguments for option \(option.rawValue)")
                }
                
                ConsoleIO.printUsage()
            
            }else{
                //3. If the argument count is good, store the two strings in local variables, check the strings and print the result.
                let first = Process.arguments[2]
                let second = Process.arguments[3]
                if first.isAnagramOfString(second) {
                    print("\(second) is an anagram of \(first)")
                }else{
                    print("\(second) is not an anagram of \(first)")
                }
            }
        case .Palindrome:
            //4. In the case of a palindrome, you must have three arguments.
            if argCount != 3 {
                if argCount > 3 {
                    print("Too many arguments for option \(option.rawValue)")
                }else{
                    print("Too few arguments for option \(option.rawValue)")
                }
            }else{
                //5. Check for the palindrome and print the result.
                let s = Process.arguments[2]
                let isPalindrome = s.isPalindrome()
                print("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
            }
        case .Help:
            //6. If the -h option was passed in, then print the usage information.
            ConsoleIO.printUsage()
        case .Unknown:
            //7. If an unknown option is passed, print the usage to the console.
            print("Unknown option \(value)")
            ConsoleIO.printUsage()
        }
    }
}