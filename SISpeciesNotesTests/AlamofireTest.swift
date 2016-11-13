//
//  AlamofireTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/18.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
@testable import Alamofire
@testable import AlamofireImage

class AlamofireTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func alamofireImage() {
        //
        let img = UIImage(named: "alert_error_icon")
        let URL = Bundle.main.url(forResource: "unicorn", withExtension: "png")!
        let data = try! Data(contentsOf: URL)
        let image = UIImage(data: data, scale: UIScreen.main.scale)!
        
        image.af_inflate()
    }
    
}
