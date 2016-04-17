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
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
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
     注意：使用自定义路径来初始化 Realm 数据库需要拥有路径所在位置的写入权限。 
     通常存储可写 Realm 文件的地方是位于 iOS 上的“Documents”文件夹以及位于 OS X 上的“Application Support”文件夹。 
     具体情况，请遵循苹果的 iOS 数据存储指南, 它推荐将文件存储在<Application_Home>/Library/Caches目录下。
     */
    //本地应用数据库和线性迁移数据库版本
    func configurationRealm()
    {
        let config = Realm.Configuration(
            // Get the path to the bundled file
            path: NSBundle.mainBundle().pathForResource("MyBundledData", ofType:"realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true,
            // 设置新的架构版本。
            //这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: 1,
            // 设置闭包，这个闭包将在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                    // enumerate(_:_:) 方法遍历了存储在 Realm 文件中的每一个“Person”对象
                    migration.enumerate(Users.className()) { oldObject, newObject in
                        // 将名字进行合并，存放在 fullName 域中
                        let firstName = oldObject!["firstName"] as! String
                        let lastName = oldObject!["lastName"] as! String
                        newObject!["fullName"] = "\(firstName) \(lastName)"
                    }
                }
            },
            //类的子集,指定对哪个类能够存储 到该配置下的Realm 数据库中，可存储的类清单。
            objectTypes:[Users.self,Users.self]
        )
        
        // Open the Realm from the bundled  with the configuration
        let realm:Realm!
        do {
            realm = try Realm(configuration: config)
        } catch let error as NSError {
            // 错误处理
            print("新建文件时错误原因:"+error.localizedDescription)
        }
    }
    
    
    //在应用中备份初始化的 Realm 数据库
    //为了能够使您的用户在应用第一次启动时就能够直接使用一些初始数据，一种通常的做法就是为应用配置初始化数据。
    func backupsRealmFileToPath(path:String)
    {
        
        //定位 realm 的所在位置，使用与最终版本相同的数据模型来创建 Realm 数据库，
        //并将您想要打包的数据放置到您的应用当中
        try! Realm().writeCopyToPath(path ,encryptionKey:getKey())
        //将您最终的 Realm 文件的压缩拷贝拖懂到您最终应用的Xcode项目导航栏中,前往您应用的Xcode Build Phase 选项卡，添加 Realm 文件到”Copy Bundle Resources”当中,这样，就能够在应用中使用这个打包好的 Realm 数据库了。 您能通过使用NSBundle.mainBundle().pathForResource(_:ofType:)来得到数据库路径
        
        //如果打包的 Realm 文件包含有您不想修改的固定数据，您也能通过为Realm.Configuration 对象设置 readOnly = true 选项，这样就可以将其从包路径直接打开了。 如果您打算修改初始数据的话，您可以通过NSFileManager.defaultManager().copyItemAtPath(_:toPath:)，将这个打包的文件拷贝到应用的 Document 文件夹下。
        
        
    }
    
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
        
        //事务也可以使用Grand Central Dispatch(GCD)在后台运行，以防止阻塞主线程。 Realm 对象并不是线程安全的，并且它也不能够跨线程共享，因此您必须要为每一个您想要执行读取或者写入操作的线程或者dispatch队列创建一个 Realm 实例。
        //当写入大量数据的时候，在一个单独事务中通过批量执行多次写入操作是非常高效的。
        try! realm.write{
            //轮询数组，逐个添加到内存数据中
            parseData().enumerateObjectsUsingBlock({ (userdata, index, nil) in
                let userDic = userdata as! NSDictionary
                //realm中,Object对象支持直接通过字典初始化
                let user = Users(value: userDic)
                //realm主键没有自增特性，所以必须index手动赋值，否则默认值为0，执行的插入的操作则变成了更新操作。
                user.index = index
                print("初始化的User对象：\(user.description)")
                //Realm数据库间拷贝数据
                //拷贝 Realm 对象到另一个 Realm 数据库十分简单，只需将原始对象传递给Realm().create(_:value:update:)。
                //例如， realm.create(MyObjectSubclass.self, value: originalObjectInstance).
                realm.create(Users.self, value: user, update: true)
            })
        }
        
        
        
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

    //使用OHHTTPStubs模拟用户信息
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

//数据库加密秘钥
func getKey() -> NSData {
    // Identifier for our keychain entry - should be unique for your application
    let keychainIdentifier = "io.Realm.EncryptionExampleKey"
    let keychainIdentifierData = keychainIdentifier.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    
    // First check in the keychain for an existing key
    var query: [NSString: AnyObject] = [
        kSecClass: kSecClassKey,
        kSecAttrApplicationTag: keychainIdentifierData,
        kSecAttrKeySizeInBits: 512,
        kSecReturnData: true
    ]
    
    // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
    // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
    var dataTypeRef: AnyObject?
    var status = withUnsafeMutablePointer(&dataTypeRef) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
    if status == errSecSuccess {
        return dataTypeRef as! NSData
    }
    
    // No pre-existing key from this application, so generate a new one
    let keyData = NSMutableData(length: 64)!
    let result = SecRandomCopyBytes(kSecRandomDefault, 64, UnsafeMutablePointer<UInt8>(keyData.mutableBytes))
    assert(result == 0, "Failed to get random bytes")
    
    // Store the key in the keychain
    query = [
        kSecClass: kSecClassKey,
        kSecAttrApplicationTag: keychainIdentifierData,
        kSecAttrKeySizeInBits: 512,
        kSecValueData: keyData
    ]
    
    status = SecItemAdd(query, nil)
    assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
    
    return keyData
}

