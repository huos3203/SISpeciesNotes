//
//  ViewController.swift
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/5/23.
//  Copyright © 2016年 recomend. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,dddProtocol,PycFileDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        let ddd = MyProtocol.init()
        ddd.delegate = self
        
//        var pycFile:PycFile! = PycFile()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func name(name: String!) {
        //
    }

}


class name:NSObject,dddProtocol,PycFileDelegate{
    //
    var ddd2 = MyProtocol.init()
    
//    var pycFile:PycFile! = PycFile()
   
    func name(name: String!) {
        //
        
        ddd2.delegate = self
        pycFile.delegate = self
    }
}
