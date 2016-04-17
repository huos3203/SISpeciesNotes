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

//使用和测试 Realm 应用的最简单方法就是使用 默认的 Realm 数据库了：Realm.Configuration.defaultConfiguration.inMemoryIdentifier。 
// 为了避免在测试中覆盖了应用数据或者泄露，您只需要为每项测试将默认的 Realm 数据库设置inMemoryIdentifier=方法名 为新文件即可。

class RealmSwiftTest: XCTestCase {

    var realm:Realm!
    override func setUp() {
        super.setUp()
        // 这确保了每个测试都不会从别的测试或者应用本身中访问或者修改数据，并且由于它们是内存数据库，因此无需对其进行清理。
        // 配置内存realm数据库，并使用当前测试名来标识的内存 Realm 数据库。
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        //在使用内存数据库时，使用inMemoryIdentifier属性代替了path属性的位置的设置
        //此刻打印出来的地址是临时地址：/tmp/-[RealmSwiftTest testupdateUserFromServer
//        print("realm文件:"+realm.path)
        //初始化默认的 Realm 数据库
        realm = try! Realm()
        
        //注入(injecting) Realm 实例：自由切换应用运行环境和测试环境下的realm文件
//        测试使用 Realm 代码的方式是让所有您打算进行测试的方法以参数的方式获取 Realm 实例，这样您就可以在应用运行和测试时将不同的 Realm 文件传递进去。
        
        //装载模拟数据拦截
        installJSONStubs()
        OHHTTPStubs.setEnabled(true) //默认是开启
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    /**
     *  @author shuguang, 16-04-17 17:04:10
     *
     *  和 public func write(@noescape block: () -> Void) throws方法冲突
     *
     *  @since 1.0
     *
         realm.beginWrite()
         realm.add(users, update: true)
         //Error handing
         do { 
                try realm.commitWrite() 
        }catch let error as NSError{
             print("commitWrite出现错误:\(error)...")
         }catch{
            print("未知错误....")
         }
     */
    //新建或更新一个对象数据
    func createOrUpdateUserInRealm(realm: Realm, withData data: NSData) {
        
        //使用嵌套函数来解析网络数据转化为实例对象, 必须在调用该函数前声明该函数
        func parseData()->NSArray
        {
            let str = String(data:data, encoding:NSUTF8StringEncoding)
            print("数据字符串：\(str!)")
            let usersDic = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary  //[String:[[String:String]]]
            return usersDic["users"]! as! NSArray
        }
        
        //轮询数组，逐个添加到内存数据中
        parseData().enumerateObjectsUsingBlock({ (userdata, index, nil) in
            
            let userDic = userdata as! NSDictionary
            //realm中,Object对象支持直接通过字典初始化
            let user = Users(value: userDic)
            //realm主键没有自增特性，所以必须index手动赋值，否则默认值为0，执行的插入的操作则变成了更新操作。
            user.index = index
            try! realm.write{
                print("初始化的User对象：\(user.description)")
                realm.create(Users.self, value: user, update: true)
            }
        })
        
        //查询结果并不是数据的拷贝：修改查询结果（在写入事务中）会直接修改硬盘上的数据
        func printAllUsers()
        {
            let usersResults = realm.objects(Users)
            for user in usersResults
            {
                print("查询出的对象:\(user.description)")
            }
        }
    }
    
    //异步访问测试获取data，添加到内存数据库
    func testupdateUserFromServer() {
        
        //在使用OHHTTPStubs拦截时，后缀名文件放在“/”后即可，不需要真实存在的路径
        let url = NSURL(string: "https://www.baidu/t.json")
        let expection = expectationWithDescription("访问网络超时")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { data, _, _ in
//                let realm = try! Realm()
            self.createOrUpdateUserInRealm(self.realm, withData: data!)
            expection.fulfill()
        }
        
        task.resume()
        waitForExpectationsWithTimeout(task.originalRequest!.timeoutInterval + 30) { error in
            print("错误原因:\(error?.localizedDescription)")
            task.cancel()
        }
    }
    
    //为了避免在测试中覆盖了应用数据或者泄露，您只需要为每项测试将默认的 Realm 数据库设置为新文件即可。
    func testThatUserIsUpdatedFromServer() {
        
        var injectRealm:Realm!
        //明确即将操作的数据库(内存、本地、应用中)
        func makeInjectRealm(injectPathOfRealm realmPath:String){
            if !realmPath.isEmpty
            {
                //
                let config = Realm.Configuration(path: realmPath)
                let testRealm = try! Realm(configuration: config)
                injectRealm = testRealm
            }
            else
            {
               injectRealm = realm  //默认是setup中设置的内存数据库
            }
        }
        
        //读取本地文件中的内容
        let jsonPath = OHPathForFile("user.json", self.dynamicType)
        let jsonData = NSData(contentsOfFile: jsonPath!)
        
        makeInjectRealm(injectPathOfRealm:"")   //isEmpty时，默认setup设置的默认内存数据库
        //注入injectRealm操作指定的数据库
        createOrUpdateUserInRealm(injectRealm, withData: jsonData!)
        //通过查询，比较name属性是否被更新
        XCTAssertEqual(injectRealm.objects(Users).first!.name,
                       "Brett2",
                       "用户信息未能从服务器正常更新。")
    }
    
    
    /**
     *  @author shuguang, 16-04-17 10:04:27
     *
     *  使用OHHTTPStubs模拟用户信息
     *
     *  @since 1
     */
    var jsonStub:OHHTTPStubsDescriptor?
    func installJSONStubs(){
        //使用self.dynamicType需要将资源文件user.json关联到本例target:SISpeciesNotesTests中
        let jsonPath = OHPathForFile("user.json", self.dynamicType)
        print("JsonStub文件路径:\(jsonPath)")
        jsonStub = stub(isExtension("json")){ _ in
            //设置拦截时间和返回模拟数据
            return fixture(jsonPath!, headers: ["Content-Type":"text/json"]).requestTime(2, responseTime: 2)
        }
        jsonStub?.name = "user.json"
    }
}


/// 模拟用户模型
class Users: Object {
    //
    dynamic var name:String = ""
    dynamic var sex:String = ""
    dynamic var age:String = ""
    
    dynamic var index:Int = 0
    
    //设置主键
    override class func primaryKey()->String?{return "index"}
    //设置索引
    override class func indexedProperties()->[String]{return ["index"]}
    
}
