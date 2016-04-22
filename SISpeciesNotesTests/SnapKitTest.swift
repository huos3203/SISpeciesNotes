//
//  SnapKitTest.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/4/22.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
@testable import SnapKit

typealias View = UIView
extension View {
    var snp_constraints: [AnyObject] { return self.constraints }
}

class SnapKitTest: XCTestCase {
   
    let container  = View()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  //添加约束
    //直接添加
    //备用装载/卸载
    
  //获取约束
    //更新已有约束
    //更新约束变量
    //添加约束Identify
    
//重置约束
    //激活与禁止
    
    //删除约束
    
    func testMakeConstraints() {
        //
        let v1 = UIView()
        let v2 = UIView()
        container.addSubview(v1)
        v1.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(container).constraint
        }
        
        XCTAssertEqual(container.snp_constraints.count , 4, "约束个数是四个")
        
        container.addSubview(v2)
        v2.snp_makeConstraints { (make) in
            //
            make.top.equalTo(v1)
            make.size.equalTo(CGSizeMake(200, 200))
        }
        XCTAssertEqual(container.constraints.count, 5, "约束个数5个")
//        XCTAssertEqual(container.constraints[0].firstItem, <#T##expression2: [T : U]##[T : U]#>, <#T##message: String##String#>)
    }
    
    
    func testUpdateConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(v2.snp_top).offset(50)
            make.left.equalTo(v2.snp_top).offset(50)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v1.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(v2.snp_top).offset(15)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should still have 2 constraints installed")
        
    }
    
    func testRemakeConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(v2.snp_top).offset(50)
            make.left.equalTo(v2.snp_top).offset(50)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v1.snp_remakeConstraints { (make) -> Void in
            make.edges.equalTo(v2)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 4 constraints installed")
        
    }
    
    func testRemoveConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(v2.snp_top).offset(50)
            make.left.equalTo(v2.snp_top).offset(50)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v1.snp_removeConstraints()
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
    }
    
    func testPrepareConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        let constraints = v1.snp_prepareConstraints { (make) -> Void in
            make.edges.equalTo(v2)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
        for constraint in constraints {
            constraint.install()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 4 constraints installed")
        
        for constraint in constraints {
            constraint.uninstall()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
    }
    
    func testReinstallConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        let constraints = v1.snp_prepareConstraints { (make) -> Void in
            make.edges.equalTo(v2)
            return
        }
        
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
        for constraint in constraints {
            constraint.install()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 4 constraints installed")
        
        for constraint in constraints {
            constraint.install()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 0 constraints installed")
    }
    
    func testActivateDeactivateConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        var c1: Constraint? = nil
        var c2: Constraint? = nil
        
        v1.snp_prepareConstraints { (make) -> Void in
            c1 = make.top.equalTo(v2.snp_top).offset(50).constraint
            c2 = make.left.equalTo(v2.snp_top).offset(50).constraint
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints")
        
        c1?.activate()
        c2?.activate()
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints")
        
        c1?.deactivate()
        c2?.deactivate()
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints")
        
        c1?.uninstall()
        c2?.uninstall()
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints")
        
        c1?.activate()
        c2?.activate()
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints")
        
    }
    
    func testSizeConstraints() {
        let view = View()
        self.container.addSubview(view)
        
        view.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(50, 50))
            make.left.top.equalTo(self.container)
        }
        
        XCTAssertEqual(view.snp_constraints.count, 2, "Should have 2 constraints")
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints")
        
        
        let constraints = view.snp_constraints as! [NSLayoutConstraint]
        
        XCTAssertEqual(constraints[0].firstAttribute, NSLayoutAttribute.Width, "Should be width")
        XCTAssertEqual(constraints[1].firstAttribute, NSLayoutAttribute.Height, "Should be height")
        XCTAssertEqual(constraints[0].constant, 50, "Should be 50")
        XCTAssertEqual(constraints[1].constant, 50, "Should be 50")
    }
    
    func testConstraintIdentifier() {
        let identifier = "Test-Identifier"
        let view = View()
        self.container.addSubview(view)
        
        view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.container.snp_top).labeled(identifier)
        }
        
        let constraints = container.snp_constraints as! [NSLayoutConstraint]
        XCTAssertEqual(constraints[0].identifier, identifier, "Identifier should be 'Test'")
    }

    
    
}
