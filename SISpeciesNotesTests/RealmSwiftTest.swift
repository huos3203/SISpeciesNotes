//
//  RealmSwiftTest.swift
//  SISpeciesNotes
//
//  Created by huoshuguang on 16/4/17.
//  Copyright © 2016年 布衣男儿. All rights reserved.
//

import XCTest
import RealmSwift   //不能使用@testable import

@testable import OHHTTPStubs  //用于模拟虚拟网络信息

class RealmSwiftTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // 使用当前测试名标识的内存 Realm 数据库。
        // 这确保了每个测试都不会从别的测试或者应用本身中访问或者修改数据，并且由于它们是内存数据库，因此无需对其进行清理。
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

        // Application Code
//        func updateUserFromServer() {
//            let url = NSURL(string: "http://myapi.example.com/user")
//            NSURLSession.sharedSession().dataTaskWithURL(url!) { data, _, _ in
//                let realm = try! Realm()
//                self.createOrUpdateUserInRealm(realm, withData: data!)
//            }
//        }
//    
//        public func createOrUpdateUserInRealm(realm: Realm, withData data: NSData) {
//            let object = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
//                as! [String: String]
//            try! realm.write {
//                realm.create(User.self, value: object, update: true)
//            }
//        }
//    
//        // Test Code
//    
//        let testRealmPath = "..."
//    
//        func testThatUserIsUpdatedFromServer() {
//            let config = Realm.Configuration(path: testRealmPath)
//            let testRealm = try! Realm(configuration: config)
//            let jsonData = "{\"email\": \"help@realm.io\"}"
//                .dataUsingEncoding(NSUTF8StringEncoding)!
//            createOrUpdateUserInRealm(testRealm, withData: jsonData)
//            let expectedUser = User()
//            expectedUser.email = "help@realm.io"
//            XCTAssertEqual(testRealm.objects(User).first!,
//                           expectedUser,
//                           "User was not properly updated from server.")
//        }
}
