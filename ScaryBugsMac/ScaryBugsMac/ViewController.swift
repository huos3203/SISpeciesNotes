//
//  ViewController.swift
//  ScaryBugsMac
//
//  Created by pengyucheng on 16/5/23.
//  Copyright © 2016年 recomend. All rights reserved.
//
//@objc
class ViewController: NSViewController,dddProtocol{

    override func viewDidLoad() {
        super.viewDidLoad()
        let ddd = MyProtocol.init()
        ddd.delegate = self
        
//        let pyc = PycFile.init()

//        PycFile.sharedPycFile().delegate = self
        MyProtocol.sharedMyProtocol().delegate = self
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

extension ViewController{
    
    func initPycFile() {
        //
//        PycFile.sharedPycFile().delegate = self
    }
    
    
    
}

class name:NSObject,dddProtocol,PycFileDelegate{
    //
    var ddd2 = MyProtocol.init()
    
//    var pycFile:PycFile! = PycFile()
   
    func name(name: String!) {
        //
        
        ddd2.delegate = self
//        pycFile.delegate = self
    }
}
