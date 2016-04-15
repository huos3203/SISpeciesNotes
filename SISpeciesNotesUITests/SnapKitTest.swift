//
//  SnapKitTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/15.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//
#if os(iOS) || os(tvOS)
    import UIKit
    typealias View = UIView
    extension View {
        var snp_constraints: [AnyObject] { return self.constraints }
    }
#else
    import AppKit
    typealias View = NSView
    extension View {
        var snp_constraints: [AnyObject] { return self.constraints }
    }
#endif

import XCTest
@testable import SnapKit

//http://snapkit.io/docs/

class SnapKitTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    let container = View()
    func testLayoutGuideConstraints() {
        #if os(iOS) || os(tvOS)
            let vc = UIViewController()
            vc.view = UIView(frame: CGRectMake(0, 0, 300, 300))
            
            vc.view.addSubview(self.container)
            
            self.container.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(vc.snp_topLayoutGuideBottom)
                make.bottom.equalTo(vc.snp_bottomLayoutGuideTop)
            }
            
            XCTAssertEqual(vc.view.snp_constraints.count, 6, "Should have 6 constraints installed")
        #endif
    }
    
}
